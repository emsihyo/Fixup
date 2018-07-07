(function(){
    Object.defineProperty(Object.prototype, '$', {value: function(name){
    //get property value outside virtual machine
    var property = ṆẠṬỊṾẸ.property(this,name);
    if (property!=null && typeof(property)!='undefined') {
        console.log('did get property:' + property +' in '+this+' by name: '+name);
        return property;
    }
    //call method outside virtual machine
    var target = this;
    return function(){
        return ṆẠṬỊṾẸ.call(target,name,Array.prototype.slice.call(arguments));
    };
   }});
})()
