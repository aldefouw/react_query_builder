class BaseTable extends React.Component {

    constructor() {
        super()

        window.ReactTable = window.ReactTable.default

        this.columns = []

        this.state = {
            data: [],
            loading: true
        }

        this.match_timestamp = new MatchDate('MM/DD/YYYY h:mmA', 'YYYY-MM-DDTHH:mm:ss +0000');
        this.match_date_time = new MatchDate('MM/DD/YYYY h:mmA', 'YYYY-MM-DDTHH:mm:ss +0000');
        this.match_date = new MatchDate('MM/DD/YYYY');
        this.match_time = new MatchTime('HH:mm:ss');
    }

    lazyLoadData(data){
        this.setState({ data: data, loading: false });
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
                defaultPageSize={25}
                defaultSorted={this.props.defaultSorted}
                className="-striped -highlight"
            />
        )
    }
}