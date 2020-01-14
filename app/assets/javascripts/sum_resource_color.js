$(function(){
  $(".shift-tables").ready(function(){
    // TODO: slickの複数日付にも対応する
    const workrole_ids = $("[data-workrole-ids]").data("workrole-ids")
    workrole_ids.forEach(function(id){
      for(let num = 8;num < 24;num++){
        sum = $(`[data-resource-type=sum][data-time=${num}][data-workrole-id=${id}]`);
        req = $(`[data-resource-type=req][data-time=${num}][data-workrole-id=${id}]`);

        if(parseInt(req[0].innerText) > parseInt(sum[0].innerText)){
          sum.addClass("not_enough_resource");
        }
      }
    })
  });
})
