angular.module 'bdate.utils', ['bdate.data']

.factory 'bDateUtils', (MESSAGES, bDataFactory) ->
  daysOfWeekList = [
    {name: 'Понедельник', short: 'Пн'}
    {name: 'Вторник', short: 'Вт'}
    {name: 'Среда', short: 'Ср'}
    {name: 'Четверг', short: 'Чт'}
    {name: 'Пятница', short: 'Пт'}
    {name: 'Суббота', short: 'Сб'}
    {name: 'Воскресенье', short: 'Вс'}
  ]

  monthObj =
    1: {name: 'Январь', short: 'Янв'}
    2: {name: 'Февраль', short: 'Фев'}
    3: {name: 'Март', short: 'Март'}
    4: {name: 'Апрель', short: 'Май'}
    5: {name: 'Май', short: 'Май'}
    6: {name: 'Июнь', short: 'Июнь'}
    7: {name: 'Июль', short: 'Июль'}
    8: {name: 'Август', short: 'Авг'}
    9: {name: 'Сентябрь', short: 'Сент'}
    10: {name: 'Октябрь', short: 'Окт'}
    11: {name: 'Ноябрь', short: 'Ноя'}
    12: {name: 'Декабрь', short: 'Дек'}

  return exports =
    daysOfWeek: daysOfWeekList
    month: monthObj
    getDaysOfWeekShorts: ->
      i = 0
      result = []
      while i < daysOfWeekList.length
        result.push daysOfWeekList[i].short
        i++
      return result
    getMonthName: (number)->
      return exports.month[number].name
    makeDateModel: (datetime) ->
      date = new Date(datetime)
      day = date.getDate()
      #TODO It's not clear what use to - .getDate() or .getUtcDate()?
      #day = date.getUTCDate()
      month = date.getMonth() + 1
      year = date.getFullYear()
      return {day: day, month: month, year: year}
    stringToDate: (dateStr, format, delimiter) ->
      formatLowerCase = format.toLowerCase()
      formatItems = formatLowerCase.split delimiter
      dateItems = dateStr.split delimiter
      monthIndex = formatItems.indexOf 'mm'
      dayIndex = formatItems.indexOf 'dd'
      yearIndex = formatItems.indexOf 'yyyy'

      year = +dateItems[yearIndex]
      month = +dateItems[monthIndex] - 1
      day = +dateItems[dayIndex]

      return false if month > 12
      return false if day > 31

      return new Date year, month, day
    isValidDate: (date)->
      if not angular.isDate
        date = new Date date

      return false if isNaN date.getTime()
    sourceCheckers:
      month:
        isMonthExist: (yearNum, monthNum, storeId) ->
          return console.error MESSAGES.invalidParams if not yearNum or not monthNum
          yearNum = +yearNum
          monthNum = +monthNum
          return false if not bDataFactory.isDataReady storeId
          return false if not bDataFactory.data[storeId].years[yearNum]
          !!bDataFactory.data[storeId].years[yearNum][monthNum]
        isPrevMonthExist: (yearNum, curMonthNum, storeId) ->
          return false if not yearNum or not curMonthNum
          #          return console.error MESSAGES.invalidParams if not yearNum or not curMonthNum
          yearNum = +yearNum
          curMonthNum = +curMonthNum

          return false if not exports.sourceCheckers.month.isMonthExist yearNum, curMonthNum, storeId
          isFirstMonth = exports.sourceCheckers.month.isFirstMonth yearNum, curMonthNum, storeId
          if not isFirstMonth
            prevMonthNum = curMonthNum - 1
            return exports.sourceCheckers.month.isMonthExist yearNum, prevMonthNum, storeId
          else
            isFirstYear = exports.sourceCheckers.year.isFirstYear yearNum, storeId
            if not isFirstYear
              prevYearNum = yearNum - 1
              lastMonthOfPrevYearNum = exports.sourceCheckers.month.getLastMonth prevYearNum, storeId
              return exports.sourceCheckers.month.isMonthExist prevYearNum, lastMonthOfPrevYearNum, storeId
            else
              return false
        getPrevMonthObj: (yearNum, curMonthNum, storeId) ->
          return console.error MESSAGES.invalidParams if not yearNum or not curMonthNum
          yearNum = +yearNum
          curMonthNum = +curMonthNum

          isFirstMonth = exports.sourceCheckers.month.isFirstMonth yearNum, curMonthNum, storeId
          if not isFirstMonth
            prevMonthNum = curMonthNum - 1
            if exports.sourceCheckers.month.isMonthExist yearNum, prevMonthNum, storeId
              return {year: yearNum, month: prevMonthNum}
            else
              return null
          else
            isFirstYear = exports.sourceCheckers.year.isFirstYear yearNum, storeId
            if not isFirstYear
              prevYearNum = yearNum - 1
              lastMonthOfPrevYearNum = exports.sourceCheckers.month.getLastMonth prevYearNum, storeId
              if exports.sourceCheckers.month.isMonthExist prevYearNum, lastMonthOfPrevYearNum, storeId
                return {year: prevYearNum, month: lastMonthOfPrevYearNum}
              else
                return null
            else
              return null
        isNextMonthExist: (yearNum, curMonthNum, storeId) ->
          return false if not yearNum or not curMonthNum
          #          return console.error MESSAGES.invalidParams if not yearNum or not curMonthNum
          yearNum = +yearNum
          curMonthNum = +curMonthNum

          return false if not exports.sourceCheckers.month.isMonthExist yearNum, curMonthNum, storeId
          isLastMonth = exports.sourceCheckers.month.isLastMonth yearNum, curMonthNum, storeId
          if not isLastMonth
            nextMonthNum = curMonthNum + 1
            return exports.sourceCheckers.month.isMonthExist yearNum, nextMonthNum, storeId
          else
            isLastYear = exports.sourceCheckers.year.isLastYear yearNum, storeId
            if not isLastYear
              nextYearNum = yearNum + 1
              firstMonthOfNextYearNum = exports.sourceCheckers.month.getFirstMonth nextYearNum, storeId
              return exports.sourceCheckers.month.isMonthExist nextYearNum, firstMonthOfNextYearNum, storeId
            else
              return false
        getNextMonthObj: (yearNum, curMonthNum, storeId) ->
          return console.error MESSAGES.invalidParams if not yearNum or not curMonthNum
          yearNum = +yearNum
          curMonthNum = +curMonthNum

          isLastMonth = exports.sourceCheckers.month.isLastMonth yearNum, curMonthNum, storeId
          if not isLastMonth
            nextMonthNum = curMonthNum + 1
            if exports.sourceCheckers.month.isMonthExist yearNum, nextMonthNum, storeId
              return {year: yearNum, month: nextMonthNum}
            else
              return null
          else
            isLastYear = exports.sourceCheckers.year.isLastYear yearNum, storeId
            if not isLastYear
              nextYearNum = yearNum + 1
              firstMonthOfNextYearNum = exports.sourceCheckers.month.getFirstMonth nextYearNum, storeId
              if exports.sourceCheckers.month.isMonthExist nextYearNum, firstMonthOfNextYearNum, storeId
                return {year: nextYearNum, month: firstMonthOfNextYearNum}
              else
                return null
            else
              return null
        getMonth: (yearNum, monthNum, storeId) ->
          return console.error MESSAGES.invalidParams if not yearNum or not monthNum
          return console.error MESSAGES.dateNotReady if not bDataFactory.isDataReady storeId
          bDataFactory.data[storeId].years[yearNum][monthNum]
        isFirstMonth: (yearNum, monthNum, storeId) ->
          return console.error MESSAGES.dateNotReady if not bDataFactory.isDataReady storeId
          yearNum = +yearNum
          monthNum = +monthNum
          monthNum is +Object.keys(bDataFactory.data[storeId].years[yearNum])[0]
        getFirstMonth: (yearNum, storeId) ->
          return console.error MESSAGES.dateNotReady if not bDataFactory.isDataReady storeId
          yearNum = +yearNum
          +Object.keys(bDataFactory.data[storeId].years[yearNum])[0]
        isLastMonth: (yearNum, monthNum, storeId) ->
          return console.error MESSAGES.dateNotReady if not bDataFactory.isDataReady storeId
          yearNum = +yearNum
          monthNum = +monthNum
          monthNum is +Object.keys(bDataFactory.data[storeId].years[yearNum])[Object.keys(bDataFactory.data[storeId].years[yearNum]).length - 1]
        getLastMonth: (yearNum, storeId) ->
          return console.error MESSAGES.dateNotReady if not bDataFactory.isDataReady storeId
          yearNum = +yearNum
          +Object.keys(bDataFactory.data[storeId].years[yearNum])[Object.keys(bDataFactory.data[storeId].years[yearNum]).length - 1]
        getNextAvailableMonth: (isForward, yearNum, monthNum, storeId) -> #TODO (S.Panfilov)
          yearNum = +yearNum
          monthNum = +monthNum
          isFirstMonth = exports.sourceCheckers.month.isFirstMonth yearNum, monthNum, storeId
          isLastMonth = exports.sourceCheckers.month.isLastMonth yearNum, monthNum, storeId
          nextYearNum = yearNum
          nextMonthNum = monthNum

          if isForward
            if not isLastMonth
              nextMonthNum = monthNum + 1
            else
              nextYearNum = yearNum + 1
              if exports.sourceCheckers.year.isYearExist nextYearNum, storeId
                nextMonthNum = exports.sourceCheckers.month.getFirstMonth nextYearNum, storeId
              else
                console.error MESSAGES.errorOnChangeMonthOrYear
                return false
          else if not isForward
            if not isFirstMonth
              nextMonthNum = monthNum - 1
            else
              nextYearNum = yearNum - 1
              if exports.sourceCheckers.year.isYearExist nextYearNum, storeId
                nextMonthNum = exports.sourceCheckers.month.getLastMonth nextYearNum, storeId
              else
                console.error MESSAGES.errorOnChangeMonthOrYear
                return false

          result =
            year: nextYearNum
            month: nextMonthNum
      year:
        isYearExist: (yearNum, storeId) ->
          return console.error MESSAGES.invalidParams if not yearNum
          return false if not bDataFactory.isDataReady storeId
          yearNum = +yearNum
          !!bDataFactory.data[storeId].years[yearNum]
        getYear: (yearNum, storeId) ->
          return console.error MESSAGES.invalidParams if not yearNum
          return console.error MESSAGES.dateNotReady if not bDataFactory.isDataReady storeId
          bDataFactory.data[storeId].years[yearNum]
        isFirstYear: (yearNum, storeId) -> #TODO (S.Panfilov)
          yearNum = +yearNum
          yearNum is +Object.keys(bDataFactory.data[storeId].years)[0]
        getFirstYear: (storeId) -> #TODO (S.Panfilov)
          return console.error MESSAGES.dateNotReady if not bDataFactory.isDataReady storeId
          +Object.keys(bDataFactory.data[storeId].years)[0]
        isLastYear: (yearNum, storeId) -> #TODO (S.Panfilov)
          return console.error MESSAGES.dateNotReady if not bDataFactory.isDataReady storeId
          yearNum = +yearNum
          yearNum is +Object.keys(bDataFactory.data[storeId].years)[Object.keys(bDataFactory.data[storeId].years).length - 1]
        getLastYear: (storeId) -> #TODO (S.Panfilov)
          return console.error MESSAGES.dateNotReady if not bDataFactory.isDataReady storeId
          +Object.keys(bDataFactory.data[storeId].years)[Object.keys(bDataFactory.data[storeId].years).length - 1]
        getNextAvailableYear: (isForward, yearNum, monthNum, storeId) ->
          yearNum = +yearNum
          monthNum = +monthNum
          isFirstYear = exports.sourceCheckers.year.isFirstYear yearNum, storeId
          isLastYear = exports.sourceCheckers.year.isLastYear yearNum, storeId
          nextYearNum = yearNum
          nextMonthNum = monthNum

          if isForward
            if not isLastYear
              nextYearNum = yearNum + 1
              if exports.sourceCheckers.month.isMonthExist nextYearNum, monthNum, storeId
                nextMonthNum = monthNum
              else
                nextMonthNum = exports.sourceCheckers.month.getFirstMonth nextYearNum, storeId
            else
              return false
          else if not isForward
            if not isFirstYear
              nextYearNum = yearNum - 1
              if exports.sourceCheckers.month.isMonthExist nextYearNum, monthNum, storeId
                nextMonthNum = monthNum
              else
                nextMonthNum = exports.sourceCheckers.month.getFirstMonth nextYearNum, storeId
            else
              return false

          result =
            year: nextYearNum
            month: nextMonthNum