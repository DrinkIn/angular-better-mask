describe 'better.mask', ->
  beforeEach module('better.mask')

  describe 'card-number-input', ->
    inputHtml = "<input name='input' ng-model='card.number' card-number-input>"
    beforeEach inject ($rootScope, $compile) ->
      @scope = $rootScope.$new()
      @input = $compile(inputHtml)(@scope)
      @model = @input.controller('ngModel')

    describe 'init', ->
      beforeEach ->
        @scope.card =
          number: '123456'
        @scope.$digest()

      it 'should not dirty or invalidate the input', ->
        expect(@input.hasClass("ng-pristine ng-valid")).toBeTruthy()

      it 'should format the input', ->
        expect(@input.val()).toBe '1234 56'
        expect(@model.$viewValue).toBe '1234 56'

      it 'should update the model', ->
        expect(@scope.card.number).toBe '123456'

    describe 'user input', ->
      beforeEach ->
        @input.val('123456').triggerHandler("input")

      it 'should format the input', ->
        expect(@input.val()).toBe '1234 56'
        expect(@model.$viewValue).toBe '1234 56'

      it 'should update the model', ->
        expect(@scope.card.number).toBe '123456'

    describe 'edge cases', ->
      it 'handles long user input', ->
        @input.val('12345678912345678').triggerHandler("input")
        expect(@scope.card.number).toBe '1234567891234567'

    describe 'non-numeric input', ->
      it 'a', ->
        @input.val('aaa').triggerHandler("input")
        expect(@input.val()).toBe ''
        expect(@model.$viewValue).toBe ''
        expect(@scope.card.number).toBe ''

  describe 'CaretPosition', ->
    inputHtml = "<input name='input' ng-model='card.number' card-number-input>"
    beforeEach inject ($rootScope, $compile, CaretPosition) ->
      @scope = $rootScope.$new()
      @input = $compile(inputHtml)(@scope)
      @model = @input.controller('ngModel')
      @caret = new CaretPosition(@input)

    it 'a', ->
      @input.val('123').triggerHandler("input")
      @caret.set(1)
      ev = angular.element.Event('keydown')
      ev.which = 192
      @input.trigger ev
  describe "credit_card_format", ->
    example_cards =
      '4242424242424242': '4242 4242 4242 4242'
      '378282246310005': '3782 822463 10005'
      '30569309025904': '3056 9309 0259 04'

    beforeEach inject ($filter) ->
      @cardFilter = $filter('credit_card_format')

    describe 'non-string values', ->
      it 'falsey', ->
        expect(@cardFilter(undefined)).toEqual ''
        expect(@cardFilter(null)).toEqual ''
        expect(@cardFilter(false)).toEqual ''
        expect(@cardFilter(NaN)).toEqual ''
        expect(@cardFilter('')).toEqual ''

      it 'numeric', ->
        expect(@cardFilter(1)).toEqual '1'
        expect(@cardFilter(1.2)).toEqual '12'

    describe 'card types', ->
      it 'should format visa correctly', ->
        expect(@cardFilter('4242424242424242')).toEqual '4242 4242 4242 4242'

      it 'should format amex correctly', ->
        expect(@cardFilter('378282246310005')).toEqual '3782 822463 10005'
        expect(@cardFilter('37828')).toEqual '3782 8'

      it 'should format diners correctly', ->
        expect(@cardFilter('30569309025904')).toEqual '3056 9309 0259 04'

    it 'should handle non-numeric charactors', ->
      expect(@cardFilter('4242 4242 4242 4242')).toEqual '4242 4242 4242 4242'
      expect(@cardFilter('3782 822463 10005')).toEqual '3782 822463 10005'
