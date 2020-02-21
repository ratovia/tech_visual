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

    // 色変え関数
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

    $(document).on('click', 'td.color_shift-data', function(){
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
        targetCell[0].dataset.workroleId = genomInfo.workrole_id
        changeWorkRoleColer(targetCell)
      })
      .fail(function(){

      })
    });
  }
})
