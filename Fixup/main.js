//ᐧ
(function(){
    Object.defineProperty(Object.prototype, 'Ċạḷḷ', {value: function(){
        //property name or method name
    var name = arguments[0]
        console.log('property js '+'name: '+name)
    if (this[name]) return this[name]
    //get property value outside virtual machine
        console.log('property oc '+'name: '+name)
    var property = $.__property__(this,name)
    if (property!=null && typeof(property)!='undefined') return property
        console.log('function '+'name: '+name)
    //call method outside virtual machine
    var target = this
    return function(){
        var ret = $.__call__(target,name,Array.prototype.slice.call(arguments));
        console.log('ret: '+ret)
        return ret
    }
   }})
})()
