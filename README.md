[![Bower version](https://badge.fury.io/bo/bdate.svg)](http://badge.fury.io/bo/bdate)
[![npm version](https://badge.fury.io/js/bdate.svg)](http://badge.fury.io/js/bdate)
[![dependency Status](https://david-dm.org/Light241/bdate/status.svg?branch=master)](https://david-dm.org/Light241/bdate#info=Dependencies)
[![devDependency Status](https://david-dm.org/Light241/bdate/dev-status.svg?branch=master)](https://david-dm.org/Light241/bdate#info=devDependencies)
[![Hex.pm](https://img.shields.io/hexpm/l/plug.svg)](https://github.com/Light241/bdate/blob/master/LICENSE)

bDate - Backend-driven Angularjs datepicker
=============
| [Demo][1] | 

#What is this?
This is angularjs datepicker (like [angular-ui datepicker][2]) but with one serious difference:
bDate Datepicker **didn't** count any date on client side, it **works only with provided (json) data**.

##But why?
There are many reasons. Mostly because sometimes you may want to set available ranges of dates from the backend. For example: you may set only aug and sept of 2014, and jan of 2015. There is do nothing with timezones - server say what is today and etc.

#Installation

* download

    with bower:
    
    ```shell
    bower install bdate --save
    ```
    
    or with npm:
    
    ```shell
    npm  install bdate --save
    ```
    
    or download directly (please use latest [release][3] version).

* add `.js` and `.css` files
    
    ```html
     <link href=bdate/dist/bdate.css rel=stylesheet media=all>
     <script src=bdate/dist/bdate.js type=text/javascript></script>
    ```
    (don't forget to include angular.js before)

* add dependency to project:
    
    ```js
    angular.module('app', [
        'bdate'
    ]);
    ```
* add directive to html:
    
    ```html
    <bdatepicker b-model="resultModel" b-source="demoData"></bdatepicker>
    ```
    
    `b-model` and `b-source` should be defined in controller's js.
    
    `b-source` - is where from we get available data
    
    `b-model` - where we save the results of select. Btw, you can use `b-model` as initial value

#Features
- 14kb for js (with injected html templates) and 6kb for css;
- No dependencies (only angularjs);
- Date data setup once and strict. If thr data provided through ajax-query, datepicker will wait until it loaded;
- No extra options (just pick a date);
- Easy to custom - you may provide custom id and class (in progress right now) for each element of each directive (if you have multiple ones);
- Able to set date model externally;

#Example

```html
<label for="bdatepicker">Date</label>
<bdatepicker b-input-id="bdatepicker" b-model="resultModel" b-source="demoData"></bdatepicker>
```

`bdatepicker` - name of the directive;

**Required**:

`b-model` - Object where selected date will be stored (also may be used as init value)

`b-source` - Object (json) where we take available dates

**Optional**:

`b-input-id` - Provides id for the directive's input element

`b-root-id` - Provides id for the directive's root element

`b-popup-id` - Provides id for the directive's popup element

**Expected json format**:

```json

{
    "format": "dd-mm-yyyy",
    "delimiter": "-",
    "today": {
        "date": 1432537266825,
        "year": 2015,
        "month": 5,
        "day": 25,
        "day_of_week": 1
    },
    "years": {
        "2015": {
            "2": {
                "days_total": 28,
                "start_day": 7
            } 
        }
    }
}
```

`format` - Now maintained only simple formats with days, month and years (**no** `EEE`, `hh:mm`). Should be only one type of delimiter (here is "`-`"), please do not pass mixed-delimiters format (**no** 'dd-MM-yy hh:mm' ).
*format is case sensetive* - `mm` - is minutes, but `MM` - is months (because on angular js politic);

`delimiter` - delimiter for `format` (in example is "`-`")

`today` - This is today's date (by server's opinion - in other world - without meaning of timezones). And todat.date is just a timestamp (in ms).

`years` - Object with available ranges. You should provide every year, which should be able to be selected. 

Each year should contain a list of available monthes (**monthes start from 1**, not 0, it's clear?).

Each month contains total days count - `days_total` (because of february) and day of week for the 1st month day  - `start_day` (for example 1st of Feb 2015 is Sunday - `7`)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/Light241/bdate/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

[1]: http://light241.github.io/bdate/
[2]: https://angular-ui.github.io/bootstrap/#/datepicker
[3]: https://github.com/Light241/bdate/releases
