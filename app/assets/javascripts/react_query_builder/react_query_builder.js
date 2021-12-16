// ReactQueryBuilder Javascript
//= require axios
//= require react
//= require moment/moment
//= require react_ujs
//= require react-table/react-table

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

    //Display Fields / Hide Fields for Queries
    QueryFieldMappings()

    // ==== REACT TABLE INITIALIZER ==== //
    const react_tables = new ReactTables();
    react_tables.initialize();

};
