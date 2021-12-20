function MatchDate (set_format = 'MM/DD/YYYY', format = 'YYYY-MM-DD +0000') {

    this.compareFilterToRow = (input, row, match, replace, replace_digits, end_format) => {
        let filter_value = input.replace(match, replace)
        let reg = moment(filter_value, end_format)
        let row_val = moment(row, format)

        if (reg.isValid() && row_val.isValid()) {
            reg = reg.format(end_format).replace(replace, replace_digits)
            return new RegExp(reg).test(row_val.format(end_format))
        }
    }

    this.filter = (input, value) => {
        if(RegExp(/\/\*\//).test(input)){
            return this.compareFilterToRow(input,
                                           value,
                                           '/*/',
                                           '/01/',
                                           '/[0-9][0-9]/',
                                           'MM/DD/YYYY' )
        } else if(RegExp(/[0-9][0-9]\/\*/).test(input)){
            return this.compareFilterToRow(input,
                                           value,
                                          '/*',
                                          '/01',
                                          '/[0-9][0-9]',
                                          'MM/DD' )
        } else {
            return moment(value, format).format(set_format).includes(input)
        }
    }

    this.return_row = (value) => {
        return moment(value, format).isValid() ?
            moment(value, format).format(set_format) :
            value
    }

}