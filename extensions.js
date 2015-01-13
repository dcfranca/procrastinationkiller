/*
  Functions to handle extensions
*/

function createExtensionComponent(element, parent, extra) {
    var extensionsList = extMng.extensions;
    var baseDir = "qrc:/extensions/";
    var objects = [];

    for (var x=0; x < extensionsList.length; x++) {
        var component = Qt.createComponent(baseDir + extensionsList[x] + "/" + element);
        if (component.status === Component.Ready) {
            console.log("-- Component " + element + " loaded");
            objects.push(component.createObject(parent, {"model": extra}));
        }
        else if (component.status === Component.Error) {
            console.log(component.errorString());
        }
    }

    return objects;
}

