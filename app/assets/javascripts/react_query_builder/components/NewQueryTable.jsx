class NewQueryTable extends BaseTable {

    constructor(props) {
        super(props)
        this.setColumns(props.cols)

        this.match_date_time = new MatchDate('MM/DD/YYYY HH:mm:ss', 'YYYY-MM-DD HH:mm:ss +0000')
        this.match_date = new MatchDate('MM/DD/YYYY', 'YYYY-MM-DD')
        this.match_time = new MatchTime('HH:mm:ss', 'YYYY-MM-DD HH:mm:ss +0000')
    }

    setColumns(cols){

        const newColumn = (col) => {

            const baseColumn = {
                Header: col.Header,
                accessor: col.accessor
            }

            let cellExtensions = {}

            if ( col.type === "datetime" ) {
                cellExtensions = {
                    Cell: row => { return this.match_date_time.return_row(row.value) },
                    filterMethod: (filter, row) => { return this.match_date_time.filter(filter.value, row[filter.id]) }
                }
            } else if ( col.type === "date" ) {
                cellExtensions = {
                    Cell: row => { return this.match_date.return_row(row.value) },
                    filterMethod: (filter, row) => { return this.match_date.filter(filter.value, row[filter.id]) }
                }
            } else if ( col.type === "time" ) {
                cellExtensions = {
                    Cell: row => { return this.match_time.return_row(row.value) },
                    filterMethod: (filter, row) => { return this.match_time.filter(filter.value, row[filter.id]) }
                }
            }

            return Object.assign({}, baseColumn, cellExtensions)

        }

        this.columns = this.columns.concat( cols.map( col => newColumn(col)) )
    }
}