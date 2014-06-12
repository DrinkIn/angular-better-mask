ensure_numeric_string = (val) ->
  val = val.toString() if angular.isNumber(val)
  return '' unless angular.isString(val)
  val.replace(/\D/g,'')



angular.module('better.mask', [])
  .filter 'betterCreditCard', ->
    (val) ->
      val = ensure_numeric_string(val)
      if val == ''
        return ''
      else if /^3[47]/.test(val)
        [val[...4], val[4...10], val[10...15]].filter(angular.identity).join(" ")
      else
        val[0..15].match(/\d{1,4}/g).join " "

  .filter 'creditCardType', ->
    (val) ->
      val = ensure_numeric_string(val)
      Stripe.cardType(val).toLowerCase().replace(" ", '-')

  .factory 'CaretPosition', ->
    class CaretPosition
      constructor: (element) ->
        @el = element[0]

      get: ->
        if @el.selectionStart isnt `undefined`
          return  @el.selectionStart
        else if document.selection
          # Curse you IE
          @el.focus()
          selection = document.selection.createRange()
          selection.moveStart "character", (if  @el.value then - @el.value.length else 0)
          return selection.text.length
        0
      set: (pos) ->
        return if @el.offsetWidth is 0 or @el.offsetHeight is 0 # Input's hidden
        if @el.setSelectionRange
          @el.focus()
          @el.setSelectionRange pos, pos
        else if @el.createTextRange
          # Curse you IE
          range = @el.createTextRange()
          range.collapse true
          range.moveEnd "character", pos
          range.moveStart "character", pos
          range.select()

  .directive 'cardNumberInput', ($filter, $parse, CaretPosition) ->
    restrict: 'A'
    require: 'ngModel'
    priority: 10
    link: (scope, element, attrs, model) ->
      caret = new CaretPosition(element)

      model.$parsers.unshift ensure_numeric_string
      model.$formatters.unshift $filter('betterCreditCard')
      setter = $parse(attrs.ngModel).assign
      old_render = model.$render

      model.$render = ->
        old_render()
        if model.$caret
          caret.set(model.$caret)
          model.$caret = null

      model.$viewChangeListeners.push ->
        view = model.$viewValue
        formatted = $filter('betterCreditCard')(view)

        if formatted != view
          console.log view
          cursor_pos = caret.get()
          if cursor_pos != view.length
            char = formatted[cursor_pos - 1]

            model.$caret = cursor_pos
            model.$caret += 1 if char == " "
          setter scope, formatted

