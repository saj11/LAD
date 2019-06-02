(function() {
  firebase.auth().onAuthStateChanged(firebaseUser => {
    if(firebaseUser){
      var email = firebase.auth().currentUser.email.replace(/\./g, '_DOT_');
      var profesorRef = firebase.database().ref().child("profesor");
      var idProfesor = profesorRef.on('value', snap => {
        var profesor = snap.val();
        for(var id in profesor) {
          if(id === email){
            document.getElementById("profesorName").textContent = profesor[id]["Nombre"] + " " + profesor[id]["Apellidos"];
            document.getElementById("profesorEmail").textContent = firebase.auth().currentUser.email;

            var table = document.getElementById('cursosTable');

            const dbEvaluationGroupRef = firebase.database().ref().child('grupo');
            dbEvaluationGroupRef.on('value', snap => {
              while(table.hasChildNodes()) {
                  table.removeChild(table.firstChild);
              }

              var groups = snap.val();
              var tablecontents = "";
              for(var group in groups) {
                var size = (groups[group]).length;
                for (var i = 1; i < size; i++) {
                  tablecontents += "<tr id='" + i +"'>";
                  tablecontents += "<td>" + groups[group][i]["IDCurso"] + "</td>";
                  tablecontents += "<td>" + groups[group][i]["NombreCurso"] + "</td>";
                  tablecontents += "</tr>";
                }
              }
              document.getElementById("cursosTable").innerHTML = tablecontents;
            });
          }
        }
      });
    }
  });

  var codigoMateria, codigoLA, activeButton;

  $('#cursosTable').on("click", "tr", function(){
    var id = $(this).find("td")[0].innerHTML;
    codigoMateria = id;

    var table = document.getElementById('numberLAD');
    const dbEvaluationLARef = firebase.database().ref().child('listaAsistencia');
    dbEvaluationLARef.on('value', snap => {
      var LAs = snap.val();
      var paggingcontents = "";
      //for(var LA in LAs) {
        if(LAs[id]){
          codigoLA = this.id;
          var size = LAs[id][this.id].length;
          for(var i = 1; i < size; i++) {
            paggingcontents += "<a class=\"\" id='" + i + "'>" + i + "</a>"
          }
          paggingcontents += "<br><hr>"
          document.getElementById("numberLAD").innerHTML = paggingcontents;
        }
    });
  })

  $('#numberLAD').on("click", "a", function(){
    if(activeButton){
      activeButton.classList.remove("active");
    }

    var numberLA = this.id;
    activeButton = this;

    this.className += "active";

    var table = document.getElementById('LATable');
    const dbEvaluationAPERef = firebase.database().ref().child('asistenciaPorEstudiante');
            dbEvaluationAPERef.on('value', snap => {
              while(table.hasChildNodes()) {
                  table.removeChild(table.firstChild);
              }

              var listaAsistencia = snap.val();
              var tablecontents = "";
              var tablaAsistencia = listaAsistencia[codigoMateria][codigoLA][numberLA];
              var key, value, cantP = 0, cantA = 0, cantT = 0;

              for ( [key, value] of Object.entries(tablaAsistencia)) {
                tablecontents += "<tr>";
                tablecontents += "<td>" + key + "</td>";
                switch(value){
                  case 'P':
                    tablecontents += "<td> Presente </td>";
                    cantP += 1;
                    break;
                  case 'A':
                    tablecontents += "<td> Ausente </td>";
                    cantA += 1;
                    break;
                  case 'T':
                    tablecontents += "<td> Tardia </td>";
                    cantT += 1;
                    break;
                }
                tablecontents += "</tr>";
                //console.log(`${key}: ${value}`);
              }
              document.getElementById("cantPresentes").innerHTML = cantP;
              document.getElementById("cantTardias").innerHTML = cantT;
              document.getElementById("cantAusentes").innerHTML = cantA;

              document.getElementById("LATable").innerHTML = tablecontents;
            });
  })

}());

