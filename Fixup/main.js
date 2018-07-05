(function(){
    Object.defineProperty(Object.prototype, "$property", {value: function(v){
        if (this.hasOwnProperty(v)) return this.v
        //get property value outside virtual machine
        return $.__property__(this,v)
    }})

    Object.defineProperty(Object.prototype, "$function", {value: function(){
    var target = this
    var func = arguments[0]
    return function(){
        $.__call__(target,func,Array.prototype.slice.call(arguments))
    }
   }})
})()
