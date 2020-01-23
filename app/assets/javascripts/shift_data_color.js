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

    const workrole_ids = $(".shift-tables").data("workrole-ids");
    const color_array = setColorArray(workrole_ids.length);

    // 色クラスが付いているところは該当の色を割り当てる
    $(".color_shift-data").each(function(){
      const workrole_id = $( this ).data("workrole-id");
      const nth = $.inArray(workrole_id, workrole_ids);
      const color = color_array[nth];

      const styles = {
        backgroundColor : color,
        border : `1px solid ${color}`,
        borderBottom : `1px solid #dee2e6`
      };
      $( this ).css(styles);
    });
  }
})
