function MatchTime (set_format = 'mm:ss', format = 'YYYY-MM-DD HH:mm:ss +0000') {

    this.filter = (input, value) => {
        return moment(value, format).format(set_format).includes(input)
    }

    this.return_row = (value) => {
        return moment(value, format).isValid() ?
        moment(value, format).format(set_format) :
        value
    }

}