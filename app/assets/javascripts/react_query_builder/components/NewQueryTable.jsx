class NewQueryTable extends React.Component {

    constructor(props) {
        super(props)

        this.columns = []

        this.state = {
            data: [],
            loading: true
        }

        this.setColumns(props.cols)

        this.match_timestamp = new MatchDate('MM/DD/YYYY h:mmA', 'YYYY-MM-DDTHH:mm:ss +0000')
        this.match_date_time = new MatchDate('MM/DD/YYYY h:mmA', 'YYYY-MM-DDTHH:mm:ss +0000')
        this.match_date = new MatchDate('MM/DD/YYYY')
        this.match_time = new MatchTime('HH:mm:ss')
    }

    lazyLoadData(data){
        this.setState({ data: data, loading: false });
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

    render() {
        const { data, loading } = this.state;

        const filterCaseInsensitiveSubString = (filter, row) => {
            const id = filter.pivotId || filter.id;
            if (row[id] !== null && typeof row[id] === 'string') {
                return (
                    row[id] !== undefined ?
                        String(row[id].toLowerCase()).includes(filter.value.toLowerCase()) : true
                )
            }
            else {
                return (
                    String(row[filter.id]).includes(filter.value)
                )
            }
        }

        return (
            <ReactTable
                data={data}
                loading={loading}
                columns={this.columns}
                showFilters={true}
                filterable
                minRows={3}
                defaultFilterMethod={filterCaseInsensitiveSubString}
                showPaginationBottom
                defaultPageSize={25}
                defaultSorted={this.props.defaultSorted}
                className="-striped -highlight"
            />
        )
    }
}