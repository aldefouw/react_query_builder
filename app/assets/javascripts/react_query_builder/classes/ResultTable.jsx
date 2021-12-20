function ResultTable () {

    this.initialize = () => {

        const columns = document.getElementById('query_columns')

        if(columns){
            const columns_data = JSON.parse(columns.getAttribute('data'))
            const query_type = columns.getAttribute('query_type')
            const query_params = columns.getAttribute('query_params')
            const display_fields = columns.getAttribute('display_fields')

            if(columns_data) {

                const url = '/query_builder.json'

                const table = document.getElementById('query_table')
                const download_excel = document.getElementById('download_excel_query_result_button')
                const download_csv = document.getElementById('download_query_result_button')

                const excel_data = JSON.parse(download_excel.getAttribute('data-react-props'))
                const csv_data = JSON.parse(download_csv.getAttribute('data-react-props'))

                if (table){
                    const selected_table = ReactDOM.render(<NewQueryTable cols={columns_data}/>, table)
                    const excel_button =  ReactDOM.render(<DownloadExcelQueryResultButton cols={columns_data} report={excel_data['report']} />, download_excel)
                    const csv_button =  ReactDOM.render(<DownloadQueryResultButton report={csv_data['report']} />, download_csv)

                    const queryData = new FormData()
                    queryData.append('query_type', query_type)
                    queryData.append('q', query_params)
                    queryData.append('display_fields', display_fields)

                    axios({
                        method: 'post',
                        url: url,
                        data: queryData,
                        transformRequest: [function (data, headers) {
                            headers['post'] = { 'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content') }
                            return data
                        }]
                    }).then(function (response) {

                        selected_table.lazyLoadData(response.data)
                        excel_button.lazyLoadData(response.data, excel_data['cols'], columns_data)
                        csv_button.lazyLoadData(response.data, csv_data['cols'], columns_data)

                    }).catch(function (error) {
                        console.log(error)
                    })

                }
            }
        }
    }
}