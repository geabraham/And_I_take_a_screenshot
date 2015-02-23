window.t = function(key) {
    if(!key){
        return "N/A";
    }

    var keys = key.split(".");
    var comp = window.I18n;
    for (i = 0; i < keys.length; i++) {
        if (comp) {
            comp = comp[keys[i]];
        }
    }


    if(!comp){
        return "[" + key + "]";
    }

    return comp;
}
