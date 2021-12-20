function AddChosen () {

    this.enable = (selectors) => {

        (function($) {

            $.fn.chosenOrder = function() {
                var $this   = this.filter('.chosen-sortable[multiple]').first(),
                  $chosen = $this.siblings('.chosen-container')

                return $($chosen.find('.chosen-choices li[class!="search-field"]').map(function() {
                    if (!this) {
                        return undefined
                    }

                    let current_field = $(this).text()
                    let selected_option = null

                    $this.find('option:contains(' + current_field + ')').each(function(i, t) {
                        if(current_field === $(t).text()){
                            selected_option = t
                        }
                    })

                    return selected_option
                }))
            }


            /*
             * Extend jQuery
             */
            $.fn.chosenSortable = function(){

                var $this = this.filter('.chosen-sortable[multiple]')

                $this.each(function(){
                    var $select = $(this)
                    var $chosen = $select.siblings('.chosen-container')

                    // On mousedown of choice element,
                    // we don't want to display the dropdown list
                    $chosen.find('.chosen-choices').bind('mousedown', function(event){
                        if ($(event.target).is('span')) {
                            event.stopPropagation()
                        }
                    })

                    // Initialize jQuery UI Sortable
                    $chosen.find('.chosen-choices').sortable({
                        'placeholder' : 'ui-state-highlight',
                        'items'       : 'li:not(.search-field)',
                        'tolerance'   : 'pointer'
                    })

                    // Intercept form submit & order the chosens
                    $select.closest('form').on('submit', function(){
                        var $options = $select.chosenOrder()
                        $select.children().remove()
                        $select.append($options)
                    })

                })

            }

        }(jQuery))

        Array.from(selectors).forEach((s)=> {
            if(document.getElementsByClassName(s).length > 0){

                //Initialize the chosen field
                $('.' + s).chosen({ allow_single_deselect: true }).chosenSortable()

                //Allow toggle
                $('.chosen-toggle').each(function(index) {
                    $(this).on('click', function(){
                        $('.' + s).
                            find('option').
                            prop('selected', $(this).hasClass('select')).parent().trigger('chosen:updated')
                    })
                })

                $('[data-toggle="tooltip"]').tooltip({
                    html: true,
                    content: function() {
                        return this.title
                    }
                })

            }
        })
    }

}