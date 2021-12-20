class DownloadQueryResultButton extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      loading: true,
      rows: []
    }
  }

  lazyLoadData(data, cols, mappings){

    const rows = []

    if(data !== undefined) {
      data.map(function (v) {
        let a = {}
        for (const s of cols) {
          const cur_obj = mappings.find(o => o.accessor === s)
          const header = cur_obj['Header']
          a[header] = v[s]
        }
        rows.push(a)
      })
    }

    this.setState({ rows: rows, loading: false })
  }

  render () {
    const { rows, loading } = this.state

    if(loading){
      return <div className="spinner-border text-dark ml-2 mr-2" role="status">
        <span className="sr-only">Loading...</span>
      </div>
    } else {
      return (
          <CSVLink data={rows}
                   filename={this.props.report + ".csv"}
                   className="btn btn-dark ml-1 mr-1"
                   target="_blank">
            <i className={"fa fa-file"} /> Export CSV
          </CSVLink>
      )
    }
  }
}