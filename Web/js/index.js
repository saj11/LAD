(function() {
	const firebaseConfig = {
	  apiKey: "AIzaSyBWGiAgl6-95-Iv5vSzdI6tLn1ZJNdF6To",
	  authDomain: "evident-axle-240422.firebaseapp.com",
	  databaseURL: "https://evident-axle-240422.firebaseio.com",
	  projectId: "evident-axle-240422",
	  storageBucket: "evident-axle-240422.appspot.com",
	  messagingSenderId: "125707044563",
	  appId: "1:125707044563:web:05b460aad7904ed4"
	};
	firebase.initializeApp(firebaseConfig);

	//Get Elements
	const loginButton = document.getElementById("loginBtn").value;

	//Add Login Event
	loginButton.addEventListener('click', e => {

		const email = document.getElementById("email_field").value;
		const pass = document.getElementById("pass_field").value;
		const auth = firebase.auth();

		window.alert(email + "  " + pass);

		auth.signInWithEmailAndPassword(email, pass);
		promise.catch(e => console.log(e.message));
	});

	firebase.auth().onAuthStateChanged(firebaseUser => {
		if(firebaseUser){
			console.log(firebaseUser);
			window.alert(firebaseUser);
			loginBtn.classList.remove('hide');
		}else{
			console.log("User not found.");
			window.alert("User not found.");
		}
	});
})