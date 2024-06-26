// A place to make modifications to how React components are loaded
//= require ./object_loader

//= require_tree ./components
//= require_tree ./classes

// ReactQueryBuilder Namespace
// https://robots.thoughtbot.com/module-pattern-in-javascript-and-coffeescript
window.ReactQueryBuilder = {}

ReactQueryBuilder.enable = function() {

    console.log('React Query Builder Enabled')

    // ==== SHOW / HIDE QUERY FIELD MAPPINGS ==== //
    QueryFieldMappings()
    console.log('Query Field Mappings')

    // ==== RESULTS TABLE INITIALIZER ==== //
    const results = new ResultTable()
    results.initialize()
    console.log('Result Table Initialized')

    // ==== CHOSEN SORTABLE OPTIONS FOR DISPLAY FIELDS ==== //
    const chosen = new AddChosen()
    let klasses = ['chosen', 'chosen-select']
    chosen.enable(klasses)
    console.log('Chosen to Display Fields')

}
