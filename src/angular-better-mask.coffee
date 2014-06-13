BetterMask = angular.module('better.mask', [])

ensure_numeric_string = (val) ->
  val = val.toString() if angular.isNumber(val)
  return '' unless angular.isString(val)
  val.replace(/\D/g,'')

filters =
  credit_card_format: (val) ->
    val = ensure_numeric_string(val)
    if val == ''
      return ''
    else if /^3[47]/.test(val)
      [val[...4], val[4...10], val[10...15]].filter(angular.identity).join(" ")
    else
      val[0..15].match(/\d{1,4}/g).join " "

  credit_card_type: (val) ->
    val = ensure_numeric_string(val)
    Stripe.cardType(val).toLowerCase().replace(" ", '-')


angular.forEach filters, (func, name) ->
  BetterMask.filter name, -> func

BetterMask
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

  .directive 'cardNumberInput', ($filter, CaretPosition) ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, model) ->
      caret = new CaretPosition(element)

      restrictCard = (e) ->
        num = String.fromCharCode(e.which)

        e.preventDefault() unless /^\d+$/.test(num)

      view_changed = (view) ->
        formatted = $filter('credit_card_format')(view)

        if formatted != view
          cursor_pos = caret.get()
          model.$setViewValue formatted
          model.$render()

          if cursor_pos != view.length
            char = formatted[cursor_pos - 1]
            cursor_pos += 1 if char == " "
            caret.set cursor_pos

      model.$parsers.unshift (val) ->
        view_changed(val)
        ensure_numeric_string(val)[..15]

      model.$formatters.unshift $filter('credit_card_format')


      element.bind 'keypress', restrictCard

