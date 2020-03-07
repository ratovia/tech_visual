$(function(){
  // 画面にshift-tableが存在したら
  if ($(".shift-tables")[0]) {
    // 16進数のランダムなカラーコードを生成する
    function randomColor(){
      let colorCode = "#";
      for(let i = 0; i < 6; i++) {
        colorCode += (16*Math.random() | 0).toString(16);
      }
      return colorCode;
    }
    // 指定された長さの、カラーコードが格納された配列を返す。
    function setColorArray(len){
      const array = [];
      for (let i=0; i<len; i++) {
        array.push(randomColor());
      }
      return array;
    }

    // 色変え関数。要素を1つ受け取って動くように修正した。
    function changeWorkRoleColer(cell) {
      // jQueryのdata()はキャッシュされるためJSのdatasetを使う
      const workrole_id = Number(cell[0].dataset.workroleId);
      if (workrole_id === 0) {
        cell.removeAttr('style')
        return;
      }
      const nth = $.inArray(workrole_id, workrole_ids);
      const color = color_array[nth];
      const styles = {
        backgroundColor : color,
        border : `1px solid ${color}`,
        borderBottom : `1px solid #dee2e6`
      };
      cell.css(styles);
    }

    const workrole_ids = $(".shift-tables").data("workrole-ids");
    const color_array = setColorArray(workrole_ids.length);

    // 色クラスが付いているところは該当の色を割り当てる
    $(".color_shift-data").each(function(){
      changeWorkRoleColer($(this));
    });

    $(document).on('click', 'td.js-update_genom', function(){
      // doneで操作するli要素を取得しておく
      const targetCell = $(this);
      const workroleId = this.dataset.workroleId;
      const genomIndex = $(this).data('genom-index');
      const shiftIndex = $(this).data('shift-index');
      const shiftInAt = $(this).data('shift-in-at');
      $.ajax({
        url: `/api/shift_generator`,
        type: 'put',
        data: {
          genom_index: genomIndex,
          shift_index: shiftIndex,
          shift_in_at: shiftInAt,
          workrole_id: workroleId,
        },
        dataType: 'json'
      })
      .done(function(genomInfo){
        // クリックした要素のdata-workrole-idを更新する
        targetCell[0].dataset.workroleId = genomInfo.after_role
        // 色変え関数にクリックした要素を渡す
        changeWorkRoleColer(targetCell)
        // 元のroleの合計リソース欄を書き換え、不足になったら赤表示用のclassをつける
        const beforeRoleCell = $(`td[data-resource-type=sum][data-genom-index=${genomInfo.genom_index}][data-workrole-id=${genomInfo.before_role}][data-time=${genomInfo.shift_in_at}]`)
        const beforeReqCount = Number($(`td[data-resource-type=req][data-genom-index=${genomInfo.genom_index}][data-workrole-id=${genomInfo.before_role}][data-time=${genomInfo.shift_in_at}]`).text())
        const beforeRoleCount = Number(beforeRoleCell.text()) - 1
        beforeRoleCell.text(beforeRoleCount)
        if (beforeRoleCount < beforeReqCount) { beforeRoleCell.addClass("not_enough_resource") }

        // 変更後のroleの合計リソース欄を書き換え、不足が解消したら赤表示用のclassを外す
        const afterRoleCell = $(`td[data-resource-type=sum][data-genom-index=${genomInfo.genom_index}][data-workrole-id=${genomInfo.after_role}][data-time=${genomInfo.shift_in_at}]`)
        const afterReqCount = Number($(`td[data-resource-type=req][data-genom-index=${genomInfo.genom_index}][data-workrole-id=${genomInfo.after_role}][data-time=${genomInfo.shift_in_at}]`).text())
        const afterRoleCount = Number(afterRoleCell.text()) + 1
        afterRoleCell.text(afterRoleCount)
        if (afterRoleCount === afterReqCount) { afterRoleCell.removeClass("not_enough_resource") }
      })
      .fail(function(){

      })
    });
  }
})
