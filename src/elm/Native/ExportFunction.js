var _user$project$Native_ExportFunction = function(){

    // expose your functions here
    return {
      functionToString: function functionToString(name, fn) {
        return { name: name, func: fn.toString() }
      }
    };
}();

