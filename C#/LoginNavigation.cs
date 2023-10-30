using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.UIElements;

public class LoginNavigation : MonoBehaviour
{

//THIS SCRIPT IS NO LONGER IN USE. SEE FIREBASECONTROLLER OR SCREENMANAGER.

//Panels
public GameObject WelcomePage;
public GameObject SelectPlatformPage;
public GameObject LoginPage;
public GameObject ForgotPage;

public Text UserInput; //text for user input
public Text LoginSpecificText; //text based on platform

// default app startup
void Start() //login page launches when user starts app
{
    //setting completion vars for tasks
    StateNameController.DD_task_complete = false;
    StateNameController.GoNoGo_task_complete = false;
    StateNameController.StopSignal_task_complete = false;

    Welcome();
}

public void Welcome(){
    WelcomePage.SetActive(true);
    SelectPlatformPage.SetActive(false);
    LoginPage.SetActive(false);
    ForgotPage.SetActive(false);
}

public void SelectPlatform(){ 
    WelcomePage.SetActive(false);
    SelectPlatformPage.SetActive(true);
    LoginPage.SetActive(false);
    ForgotPage.SetActive(false);
}

public void PlatformIsMTURK(){
    StateNameController.platform = "MTURK";
    LoginSpecificText.text = "Please enter your MTURK Participant ID:";
    Login();
}

public void Login(){
    WelcomePage.SetActive(false);
    SelectPlatformPage.SetActive(false);
    LoginPage.SetActive(true);
    ForgotPage.SetActive(false);
}

//might use for MTURK users who forget ID
public void ForgotMyLogin(){
    WelcomePage.SetActive(false);
    SelectPlatformPage.SetActive(false);
    LoginPage.SetActive(false);
    ForgotPage.SetActive(true);
}

public void LoggedIn(){
    StateNameController.MTURK_participant_ID = UserInput.text;
    Debug.Log(StateNameController.MTURK_participant_ID);
    SceneManager.LoadScene("TaskListPage");
}

}
