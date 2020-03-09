$(function(){
  // 画面にshift-tableが存在したら
  if ($(".shift-tables")[0]) {
    // 16進数のランダムなカラーコードを生成する
    const randomColor = ()=>{
      let colorCode = "#";
      for(let i = 0; i < 6; i++) {
        colorCode += (16*Math.random() | 0).toString(16);
      }
      return colorCode;
    }
    // 指定された長さの、カラーコードが格納された配列を返す。
    const setColorArray = len => {
      const array = [];
      for (let i=0; i<len; i++) {
        array.push(randomColor());
      }
      return array;
    }

    // 色変え関数。要素を1つ受け取って動くように修正した。
    const changeWorkRoleColer = cell => {
      // jQueryのdata()はキャッシュされるためJSのdatasetを使う
      const workrole_id = Number(cell[0].dataset.workroleId);
      if (workrole_id === 0) {
        cell.removeAttr('style')
        cell.addClass('no_workrole')
        return;
      }
      cell.removeClass('no_workrole')
      const nth = $.inArray(workrole_id, workrole_ids);
      const color = color_array[nth];
      const styles = {
        backgroundColor : color,
        border : `1px solid ${color}`,
        borderBottom : `1px solid #dee2e6`
      };
      cell.css(styles);
    }

    // シフトクリック時のdoneで実行する関数
    // クリックしたセルのworkrole更新＆色変え + 合計リソースの更新
    const updateShiftCell = (cell, genomInfo) => {
      cell[0].dataset.workroleId = genomInfo.after_role
      changeWorkRoleColer(cell)
      // 元のroleの合計リソース欄を書き換え、不足になったら赤表示用のclassをつける
      const beforeRoleCell = $(`td[data-resource-type=sum][data-date=${genomInfo.date}][data-workrole-id=${genomInfo.before_role}][data-time=${genomInfo.shift_in_at}]`)
      const beforeReqCount = Number($(`td[data-resource-type=req][data-date=${genomInfo.date}][data-workrole-id=${genomInfo.before_role}][data-time=${genomInfo.shift_in_at}]`).text())
      const beforeRoleCount = Number(beforeRoleCell.text()) - 1
      beforeRoleCell.text(beforeRoleCount)
      if (beforeRoleCount < beforeReqCount) { beforeRoleCell.addClass("not_enough_resource") }

      // 変更後のroleの合計リソース欄を書き換え、不足が解消したら赤表示用のclassを外す
      const afterRoleCell = $(`td[data-resource-type=sum][data-date=${genomInfo.date}][data-workrole-id=${genomInfo.after_role}][data-time=${genomInfo.shift_in_at}]`)
      const afterReqCount = Number($(`td[data-resource-type=req][data-date=${genomInfo.date}][data-workrole-id=${genomInfo.after_role}][data-time=${genomInfo.shift_in_at}]`).text())
      const afterRoleCount = Number(afterRoleCell.text()) + 1
      afterRoleCell.text(afterRoleCount)
      if (afterRoleCount === afterReqCount) { afterRoleCell.removeClass("not_enough_resource") }
    }


    const workrole_ids = $(".shift-tables").data("workrole-ids");
    const color_array = setColorArray(workrole_ids.length);

    // 色クラスが付いているところは該当の色を割り当てる
    $(".color_shift-data").each(function(){
      changeWorkRoleColer($(this));
    });

    // shift_generators#update用
    $('td.js-update_genom').on('click', function(){
      // doneで操作するli要素を取得しておく
      const targetCell = $(this);
      const day = $(this).parents().find('.shift-table').data('date')
      const workroleId = this.dataset.workroleId;
      const genomIndex = $(this).data('genom-index');
      const shiftIndex = $(this).data('shift-index');
      const shiftInAt = $(this).data('shift-in-at');
      $.ajax({
        url: `/api/shift_generator`,
        type: 'put',
        data: {
          day: day,
          genom_index: genomIndex,
          shift_index: shiftIndex,
          shift_in_at: shiftInAt,
          workrole_id: workroleId,
        },
        dataType: 'json'
      })
      .done(function(genomInfo){
        updateShiftCell(targetCell, genomInfo)
      })
      .fail(function(){

      })
    });
    // shifts#update用
    $('td.js-update_shift').on('click', function(){
      const targetCell = $(this)
      const targetSiblings = $(this).parent().children()
      const day = $(this).parents().find('.shift-table').data('date')
      const newWorkRole = Number(targetCell[0].dataset.workroleId) + 1
      let userId
      // user_genom[:shift]に当たるものを作る
      let shiftArray = []
      targetSiblings.each(function(index, ele){
        if (index === 0){
          userId = ele.dataset.userId
        } else if (index < 9) {
          shiftArray.push(null)
        } else if (index === targetCell.data('shift-in-at') + 1) {
          shiftArray.push(newWorkRole)
        } else {
          shiftArray.push(ele.dataset.workroleId || null)
        }
      })
      $.ajax({
        url: '/shifts',
        type: 'put',
        data: {
          day: day,
          user_id: userId,
          shift_array: shiftArray
        },
        dataType: 'json'
      })
      .done(function(genomInfo){
        // シフト更新時はgenomInfoが空なのでここで作る
        genomInfo.date = day
        genomInfo.shift_in_at = targetCell[0].dataset.shiftInAt
        genomInfo.before_role = targetCell[0].dataset.workroleId
        genomInfo.after_role = workrole_ids.indexOf(newWorkRole) === -1 ? 0 : newWorkRole
        updateShiftCell(targetCell, genomInfo)
      })
      .fail(function(res){
        console.log(res.error)
      })
    })
  }
})
