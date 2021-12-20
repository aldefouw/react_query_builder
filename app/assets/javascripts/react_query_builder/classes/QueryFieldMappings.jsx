function QueryFieldMappings () {

    this.toggle = () => {

        const display_fields = $('#display_fields_button')
        const hide_fields = $('#hide_fields_button')
        const query_fields = $('#query_fields')

        display_fields.click((e) => {
            e.preventDefault()
            display_fields.hide()
            hide_fields.show()
            query_fields.fadeIn()
        })

        hide_fields.click((e) => {
            e.preventDefault()
            hide_fields.hide()
            display_fields.show()
            query_fields.fadeOut()
        })

    }

}