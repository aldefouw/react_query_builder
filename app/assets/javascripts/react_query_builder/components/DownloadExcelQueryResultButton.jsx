class DownloadExcelQueryResultButton extends React.Component {

	constructor(props) {
		super(props)
		this.state = {
			loading: true,
			rows: []
		}
	}

	getColumnMappings (xls, cols){
		let column_mappings = {}

		Object.keys(xls).forEach(function(key) {
			if(key[key.search(/\d/)] === '1'){
				for (const s of cols) {
					if(s['Header'] === xls[key]['v']){
						column_mappings[key.slice(0, -1)] = s['type']
					}
				}
			}
		})

		return column_mappings
	}


	timeZoneAdjustment (date_value, format){
		let date_tz_offset = new Date(date_value).getTimezoneOffset()
		let user_tz_offset = new Date().getTimezoneOffset()
		let date = moment(date_value, format).utc()

		if(user_tz_offset > date_tz_offset){
			date.add(1, 'hour')
		} else if (user_tz_offset < date_tz_offset) {
			date.subtract(1, 'hour')
		}

		return date
	}

	reformatDatesTimesAndNumbers (xls, cols) {
		let column_mappings = this.getColumnMappings(xls, cols)
		let outside = this
		let t = {}

		Object.keys(xls).forEach(function(key){

			t[key] = xls[key]

			let length = key.search(/\d/)
			let column = key.substring(0, length)
			let type =  column_mappings[column]
			var row = key.substring(key.indexOf(column) + column.length)
			let row_type = typeof(xls[key])

			if(row_type !== "string" &&
				row !== '1' &&
				t[key]['v'] !== null
			){
				if(type === "datetime"){
					t[key]['v'] = outside.timeZoneAdjustment(t[key]['v'], 'YYYY-MM-DD HH:mm:ss +0000')
					t[key]['t'] = 'd'
					t[key]['z'] = 'mm/dd/yyyy hh:mm:ss'
				} else if (type === "date"){
					t[key]['v'] = outside.timeZoneAdjustment(t[key]['v'], 'YYYY-MM-DD +0000')
					t[key]['t'] = 'd'
					t[key]['z'] = 'mm/dd/yyyy'
				} else if (type === "time"){
					t[key]['v'] = t[key]['v'].split(' ')[1]
				} else if (type === "integer" && Number.isInteger(t[key]['v'])){
					//It might be tempting to combine this conditional with decimal since they are both "numbers"
					//The problem is we cannot guarantee an integer type on values
					//Remember, Rails has enums in the DB as type integer even though value output is a string
					//In conditional, we check to make sure the value is ACTUALLY an integer and then we could set to n (number)
					t[key]['t'] = 'n'
				} else if (type === "decimal"){
					t[key]['t'] = 'n'
				} else if (type === "boolean"){
					// It might be tempting to change this to b for boolean.
					// Please don't as it will cause problems.
					// It won't show blank data, for instance.
					t[key]['t'] = 's'
				}

			}

		} )

		return t
	}

	downloadFile (event, rows, report, cols) {
		event.preventDefault()

		const wb = XLSX.utils.book_new()
		const xls = XLSX.utils.json_to_sheet(rows)
		const data = this.reformatDatesTimesAndNumbers(xls, cols)

		if(xls !== undefined) {
			XLSX.utils.book_append_sheet(wb, data, this.trimToLimit(report, 30))
			XLSX.writeFile(wb, report + '.xlsx')
		}
	}

	trimToLimit (str, limit) {
		return str.length > limit - 4 ? str.substring(0, limit - 4) + " ..." : str
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
			return <div className="spinner-border text-info ml-2 mr-2" role="status">
				<span className="sr-only">Loading...</span>
			</div>
		} else {
			return <Button onClick={(e) => { this.downloadFile(e, rows, this.props.report, this.props.cols) }}
						   className={"btn btn-info ml-1 mr-1"}
						   label={<span><i className={"fa fa-table"} /> Export Excel</span>}/>
		}
	}
}
