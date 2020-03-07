$(function(){
  if ($('.admin-shifts')[0]) {
    console.log(1)
    $('td.js-update_shift').on('click', function(){
      const targetLi = $(this)
      const targetSiblings = $(this).parent().children()
      const day = $(this).parents().find('.shift-table').data('date')
      let userId
      let shiftArray = []
      console.log()
      targetSiblings.each(function(index, ele){
        if (index === 0){
          userId = ele.dataset.userId
        } else if (index < 7) {
          shiftArray.push(0)
        } else if (index === targetLi.data('shift-in-at') + 1) {
          console.log('変更点')
          console.log(ele)
          shiftArray.push(Number(ele.dataset.workroleId) + 1)
        } else {
          shiftArray.push(ele.dataset.workroleId || 0)
        }
      })
      console.log(userId)
      console.log(day)
      console.log(shiftArray)
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
      .done(function(user_shifts){
        console.log(user_shifts)
      })
      .fail(function(res){
        console.log(res.error)
      })
    })
  }
})
