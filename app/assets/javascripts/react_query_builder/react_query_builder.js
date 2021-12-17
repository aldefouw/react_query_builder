// ReactQueryBuilder Javascript
//= require axios
//= require moment/moment

//= require react
//= require react_ujs
//= require react-table/react-table
//= require react-csv
//= require xlsx

//= require ./object_loader

//= require_tree ./components
//= require_tree ./classes

// Add this method within your initialization block:
// Vanilla:
// document.addEventListener("DOMContentLoaded", function(event) {
//   ReactQueryBuilder.enable();

// Turbolinks:
// document.addEventListener("turbolinks:load", function(event) {
//   ReactQueryBuilder.enable();


// ReactQueryBuilder Namespace
// https://robots.thoughtbot.com/module-pattern-in-javascript-and-coffeescript
window.ReactQueryBuilder = {};


ReactQueryBuilder.enable = function() {

    console.log('React Query Builder Enabled')

    //Search Functionality
    Search()

    console.log('Search Enabled')

    //Display Fields / Hide Fields for Queries
    QueryFieldMappings()
    console.log('Query Field Mappings')

    // ==== REACT TABLE INITIALIZER ==== //
    const react_tables = new ReactTables();
    react_tables.initialize();

};
