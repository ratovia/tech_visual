$(function(){
  $(".shift-tables").ready(function(){
    const workrole_ids = $("[data-workrole-ids]").data("workrole-ids")
    $("[data-date]").each(function(){
      let _this = this;
      workrole_ids.forEach(function(id){
        for(let num = 8;num < 24;num++){
          sum = $(_this).find(`[data-resource-type=sum][data-time=${num}][data-workrole-id=${id}]`);
          req = $(_this).find(`[data-resource-type=req][data-time=${num}][data-workrole-id=${id}]`);
          if(parseInt(req[0].innerText) > parseInt(sum[0].innerText)){
            sum.addClass("not_enough_resource");
          }
        }
      })
    })
  });
})
