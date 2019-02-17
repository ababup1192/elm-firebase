'use strict';

require("./styles.scss");

const {Elm} = require('./Main');
const app = Elm.Main.init();

const config = {
  apiKey: "AIzaSyDbLVw9Q6g2lUaNipRM5s4iY8473NjaBRo",
  authDomain: "elm-test-cd8f5.firebaseapp.com",
  databaseURL: "https://elm-test-cd8f5.firebaseio.com",
  projectId: "elm-test-cd8f5",
  storageBucket: "elm-test-cd8f5.appspot.com",
  messagingSenderId: "763417578738"
};
firebase.initializeApp(config);
const provider = new firebase.auth.GoogleAuthProvider();
const DB = firebase.firestore();

// ログイン監視
firebase.auth().onAuthStateChanged((user) => {
  if (user) {
    app.ports.signedIn.send(true);

    // ログイン後にDatabase監視
    DB.collection('foo').doc(user.uid).onSnapshot((doc) => {
        const data = doc.data();
        app.ports.read.send(data.input);
    });
  }
});

app.ports.signIn.subscribe(_ => {
  firebase.auth().signInWithPopup(provider).then((_) => {}).catch((error) => {});
});

app.ports.push.subscribe(text => {
  const user = firebase.auth().currentUser;
  DB.collection('foo').doc(user.uid).set({input: text});
});
