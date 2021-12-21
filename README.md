# React Query Builder

## Install Migrations and Models
`rails g react_query_builder:install`

## Run Migrations
`rails db:migrate`


## Add to Gemfile
```
gem 'react_query_builder'
gem 'react-rails'
gem 'bootstrap', "~> 4.1"
gem 'reform', "~> 2.2"
gem 'reform-rails', "~> 0.1"
gem 'chosen-rails', "~> 1.9"
gem 'simple_form'
gem 'jquery-ui-rails', '~> 6.0'
```


### Optional Javascript
Add following items to `/app/assets/javascripts/application.js` if needed
```
//= require jquery
//= require jquery_ujs
```


### Add a New Model & View
```
rails g scenic:view qb_my_new_model
```

Button CSS Styling

### Apply to All Buttons:
```
# ALL BUTTONS
.rqb_btn { }
```

### Apply to Specific Buttons:
```
# BACK
.rqb_back_btn { }

# RUN
.rqb_run_btn { }

# EDIT
.rqb_edit_btn { }

# DELETE
.rqb_delete_btn { }

# EXCEL
.rqb_excel_btn { }

# CSV 
.rqb_csv_btn { }

# SAVE AS
.rqb_save_as_btn { }

# SAVE
.rqb_save_btn { }

# NEW QUERY
.rqb_new_query_btn { }

# BACK
.rqb_back_btn { }

# DISPLAY FIELDS
.rqb_display_fields_btn { }

```

