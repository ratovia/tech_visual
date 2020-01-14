$(function(){
  $(".shift-tables").ready(function(){
    // TODO: slickの複数日付にも対応する
    const workrole_ids = $("[data-workrole-ids]").data("workrole-ids")
    workrole_ids.forEach(function(id){
      for(let num = 8;num < 24;num++){
        // XXX: num=8の時、data-time=9のデータが取れてしまう。
        sum = $(`[data-resource-type=sum]+[data-time=${num - 1}]+[data-workrole-id=${id}]`);
        req = $(`[data-resource-type=req]+[data-time=${num - 1}]+[data-workrole-id=${id}]`);

        if(parseInt(req[0].innerText) > parseInt(sum[0].innerText)){
          sum.addClass("not_enough_resource");
        }
      }
    })
  });
})
