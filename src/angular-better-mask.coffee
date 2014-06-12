angular.module 'better.mask', []
  .filter 'betterCreditCard', ->
    (val) ->
      val[0..15].match(/.{1,4}/g).join " "
