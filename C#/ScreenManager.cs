using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.UIElements;

public class ScreenManager : MonoBehaviour
{

  //list object variables
  public GameObject LoginSystem;
  public GameObject DelayDicounting;
  public GameObject GoNoGo;
  public GameObject StopSignal;
  public GameObject ProbabilisticReward;
  public GameObject BART;

  public GameObject DDTaskBar;
  public GameObject GoNoGoTaskBar;
  public GameObject StopSignalTaskBar;
  public GameObject BARTTaskBar;

  // default app startup
  void Start(){}
  
  public void OpenLogin(){
    //show/hide task bars based on completion
    
    /*if(StateNameController.DD_task_complete) { DDTaskBar.SetActive(false); }
    else { DDTaskBar.SetActive(true); }
    if(StateNameController.GoNoGo_task_complete) { GoNoGoTaskBar.SetActive(false); }
    else { GoNoGoTaskBar.SetActive(true); }
    if(StateNameController.StopSignal_task_complete) { StopSignalTaskBar.SetActive(false); }
    else { StopSignalTaskBar.SetActive(true); }*/

    LoginSystem.SetActive(true);
    DelayDicounting.SetActive(false);
    GoNoGo.SetActive(false);
    StopSignal.SetActive(false);
    ProbabilisticReward.SetActive(false);
    BART.SetActive(false);
   }

  public void OpenDelayDicounting(){
        LoginSystem.SetActive(false);
        DelayDicounting.SetActive(true);
        GoNoGo.SetActive(false);
        StopSignal.SetActive(false);
        ProbabilisticReward.SetActive(false);
        BART.SetActive(false);
       
    }

  public void OpenGoNoGo(){
        LoginSystem.SetActive(false);
        DelayDicounting.SetActive(false);
        GoNoGo.SetActive(true);
        StopSignal.SetActive(false);
        ProbabilisticReward.SetActive(false);
        BART.SetActive(false);
     
    }

  public void OpenStopSignal(){
        LoginSystem.SetActive(false);
        DelayDicounting.SetActive(false);
        GoNoGo.SetActive(false);
        StopSignal.SetActive(true);
        ProbabilisticReward.SetActive(false);
        BART.SetActive(false);
        
    }

  public void OpenProbabilisticReward(){

        LoginSystem.SetActive(false);
        DelayDicounting.SetActive(false);
        GoNoGo.SetActive(false);
        StopSignal.SetActive(false);
        ProbabilisticReward.SetActive(true);
        BART.SetActive(false);

    }

public void OpenBART(){
        LoginSystem.SetActive(false);
        DelayDicounting.SetActive(false);
        GoNoGo.SetActive(false);
        StopSignal.SetActive(false);
        ProbabilisticReward.SetActive(false);
        BART.SetActive(true);
       
    }
 


}
