$(document).ready(function(){
  var screenings = $('.screening-group .screening');

  if(screenings.length > 0){
    var now = new Date();
    var targets = screenings.not('.past');

    targets.each(function(i, target){
      var dateText = $(target).find('.date').text();
      var recentDate = dateText.split('–');

      // handle daterange as the last one
      if(recentDate.length > 1){
        dateText = recentDate[1];
      }

      var dateParts = dateText.split('.');

      //fix string iso format
      dateParts[2] = "2016";

      var date = Date.parse(dateParts.join('-'));

      // these should be milliseconds since epoch
      if(date < now.getTime()){
        $(target).removeClass('confirmed').addClass('past');
      }
    })
  }
})
