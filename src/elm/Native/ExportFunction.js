var _user$project$Native_ExportFunction = function(){

        window.$functions = []
    // expose your functions here
    return {
      functionToString: function functionToString(name, fn) {
        return { name: name, func: fn.toString() }
      }
    };
}();

