//Need CSVLink and CSVDownload specified in root of window object rather than within ReactCSV
window.CSVLink = window.ReactCSV.CSVLink
window.CSVDownload = window.ReactCSV.CSVDownload

console.log('React CSV objects initialized')

//Specify the default object
window.ReactTable = window.ReactTable.default

console.log('React Table object initialized')