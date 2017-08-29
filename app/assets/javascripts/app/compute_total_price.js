  // // definition of each variable that will be needed for condition testing
  //   let start_date = document.getElementById("start_date")
  //   let end_date = document.getElementById("end_date")
  //   let pax_nb = document.getElementById("pax_nb")
  //   let total_price = document.getElementById("total-price")


  //   // Function to get the date to the right format
  //   function rightDate(date){
  //     var split_date = date.split('/');
  //     var right_date = new Date(split_date[2],split_date[1]-1,split_date[0]);
  //     return right_date
  //   };

  //   function numberOfNights(start_date, end_date) {
  //     let night = ( Math.floor((end_date - start_date) / (1000*60*60*24)) - 1 )
  //     return night
  //   };

  //   function arrayOfDates(start_date, night) {
  //     let dates = [];
  //     for (i = 0; i <= night; i++) {
  //       dates.push(start_date.setDate(start_date.getDate() + i));
  //     };
  //     return dates
  //   };

  //   function totalPrice(night, dates, pax_nb){
  //     let price = 0
  //     for (j = 0; j <= night; j++) {
  //       let date = dates[j]
  //       if ( date >= <%= ((@surfcamp.discounts.first.discount_starts_at.to_i * 1000) - 7200000 ) %> && date < <%= ((@surfcamp.discounts.first.discount_ends_at.to_i * 1000) - 7200000) %> ) {
  //         // prix du jour = prix discount * nb personne
  //           price += (<%= @surfcamp.discounts.first.discounted_price %> * pax_nb.value);
  //         } else {
  //             // prix du jour = prix normal * nb personne
  //             price += (<%= @surfcamp.price_per_night_per_person %> * pax_nb.value);
  //           };
  //         };
  //       return price;
  //   };

  //   // Function to test if all the necessary fields are filled (start, end, pax)
  //   function fieldsFilled(start_date, end_date, pax_nb) {
  //     if(Boolean(start_date.value) && (end_date.value) && (pax_nb.value)){
  //       // execute some code to have proper date
  //       let right_start_date = rightDate(start_date.value);
  //       let right_end_date = rightDate(end_date.value);

  //       // execute code to get the number of night in a given period
  //       let night = numberOfNights(right_start_date, right_end_date)

  //       // test if number of night is lower than zero

  //       // execute some code to get an array of date
  //       let dates = arrayOfDates(right_start_date, night);

  //       // execute some code to check if there is a promotion and calculate price
  //       let finalPrice = totalPrice(night, dates, pax_nb)

  //       // Add the total price to the div Total-price in the HTML
  //       total_price.innerHTML = `<p>Total:</p><p>${finalPrice}€</p>`;
  //     } else {
  //       // Just to log if the condition is not respected
  //       console.log("no");
  //     };
  //   };


  //   $('#start_date').datepicker()
  //     .on("input change", function (e) {
  //     var start_date = e.target;
  //     fieldsFilled(start_date, end_date, pax_nb)
  //   });

  //   $('#end_date').datepicker()
  //     .on("input change", function (e) {
  //     var date = e.target;
  //     fieldsFilled(start_date, end_date, pax_nb)
  //   });

  //   $('#pax_nb').datepicker()
  //     .on("input change", function (e) {
  //     var date = e.target;
  //     fieldsFilled(start_date, end_date, pax_nb)
  //   });
