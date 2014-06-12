angular.module('demo', ['better.mask'])
  .value 'StripeTestCards',
    '4242424242424242': 'Visa'
    '4012888888881881': 'Visa'
    '4000056655665556': 'Visa (debit card)'
    '5555555555554444': 'MasterCard'
    '5105105105105100': 'MasterCard'
    '5200828282828210': 'MasterCard (debit card)'
    '378282246310005': 'American Express'
    '371449635398431': 'American Express'
    '6011111111111117': 'Discover'
    '6011000990139424': 'Discover'
    '30569309025904': 'Diners Club'
    '38520000023237': 'Diners Club'
    '3530111333300000': 'JCB'
    '3566002020360505': 'JCB'
  .controller 'CardExampleCtrl', ($scope, StripeTestCards) ->
    $scope.test_cards = StripeTestCards
    $scope.select_num = (num) ->
      $scope.card ||= {}
      $scope.card.number = num
