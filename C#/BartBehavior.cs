using System.Collections;
using System.Collections.Generic;  
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.UIElements;
using Random = System.Random;


public class BartBehavior : MonoBehaviour
{


    public GameObject BeforeYouStart;
    public GameObject Instructions;
    public GameObject TrialInstructions;
    public GameObject Trial;
    public GameObject Trial2;
    public GameObject TrialEnd;
    public GameObject BalloonPumpPage;
    public GameObject BalloonPopPage;
    public GameObject BalloonSuccessPage;
    public GameObject ThankYou;
    public Text CurrentPumps;
    public Text SliderPumps;
    public Text CurrentReward;
    public Text TotalReward;
    public UnityEngine.UI.Slider mySlider;
    

    //game variables
    ArrayList range = new ArrayList();
    ArrayList balloons = new ArrayList();
    Random random = new Random();
    public int pop_point;
    public int originalpop;
    public int pump; 
    //public int pumptracker;
    public double total_reward;
    public double initreward;
    public int trial = 0;
    IDictionary<int, ArrayList> trial_pop_pump = new Dictionary<int, ArrayList>();
    ArrayList decisionvalues = new ArrayList();
    IDictionary<int, string> trial_decisions = new Dictionary<int, string>();



    // default app startup
    void Start(){
        //OpenWelcomePanel();
    }

    public void OpenHomePage(){
        //SceneManager.LoadScene("LogInSystem");
    }

    public void OpenWelcomePanel(){
        BeforeYouStart.SetActive(true);
        Instructions.SetActive(false);
        TrialInstructions.SetActive(false);
        Trial.SetActive(false);
        Trial2.SetActive(false);
        TrialEnd.SetActive(false);
        BalloonPumpPage.SetActive(false);
        BalloonPopPage.SetActive(false);
        BalloonSuccessPage.SetActive(false);
        ThankYou.SetActive(false);

        //initialize range arraylist and balloons
    }

    public void OpenInstructionsPanel(){
        BeforeYouStart.SetActive(false);
        Instructions.SetActive(true);
        TrialInstructions.SetActive(false);
        Trial.SetActive(false);
        Trial2.SetActive(false);
        TrialEnd.SetActive(false);
        BalloonPumpPage.SetActive(false);
        BalloonPopPage.SetActive(false);
        BalloonSuccessPage.SetActive(false);
        ThankYou.SetActive(false);
    }

    public void OpenTrialInstructions(){
        BeforeYouStart.SetActive(false);
        Instructions.SetActive(false);
        TrialInstructions.SetActive(true);
        Trial.SetActive(false);
        Trial2.SetActive(false);
        TrialEnd.SetActive(false);
        BalloonPumpPage.SetActive(false);
        BalloonPopPage.SetActive(false);
        BalloonSuccessPage.SetActive(false);
        ThankYou.SetActive(false);
    }
    public void OpenTrial(){
        BeforeYouStart.SetActive(false);
        Instructions.SetActive(false);
        TrialInstructions.SetActive(false);
        Trial.SetActive(true);
        Trial2.SetActive(false);
        TrialEnd.SetActive(false);
        BalloonPumpPage.SetActive(false);
        BalloonPopPage.SetActive(false);
        BalloonSuccessPage.SetActive(false);
        ThankYou.SetActive(false);
    }

    public void OpenTrial2(){
        BeforeYouStart.SetActive(false);
        Instructions.SetActive(false);
        TrialInstructions.SetActive(false);
        Trial.SetActive(false);
        Trial2.SetActive(true);
        TrialEnd.SetActive(false);
        BalloonPumpPage.SetActive(false);
        BalloonPopPage.SetActive(false);
        BalloonSuccessPage.SetActive(false);
        ThankYou.SetActive(false);
    }

    public void OpenTrialEnd(){
        BeforeYouStart.SetActive(false);
        Instructions.SetActive(false);
        TrialInstructions.SetActive(false);
        Trial.SetActive(false);
        Trial2.SetActive(false);
        TrialEnd.SetActive(true);
        BalloonPumpPage.SetActive(false);
        BalloonPopPage.SetActive(false);
        BalloonSuccessPage.SetActive(false);
        ThankYou.SetActive(false);
    }

    public void OpenBalloonPumpPage(){
        BeforeYouStart.SetActive(false);
        Instructions.SetActive(false);
        TrialInstructions.SetActive(false);
        Trial.SetActive(false);
        Trial2.SetActive(false);
        TrialEnd.SetActive(false);
        BalloonPumpPage.SetActive(true);
        BalloonPopPage.SetActive(false);
        BalloonSuccessPage.SetActive(false);
        ThankYou.SetActive(false);
    }

    public void OpenBalloonSuccessPanel(){
        BeforeYouStart.SetActive(false);
        Instructions.SetActive(false);
        TrialInstructions.SetActive(false);
        Trial.SetActive(false);
        Trial2.SetActive(false);
        TrialEnd.SetActive(false);
        BalloonPumpPage.SetActive(false);
        BalloonPopPage.SetActive(false);
        BalloonSuccessPage.SetActive(true);
        ThankYou.SetActive(false);
    }

    public void OpenBalloonPopPage(){
        BeforeYouStart.SetActive(false);
        Instructions.SetActive(false);
        TrialInstructions.SetActive(false);
        Trial.SetActive(false);
        Trial2.SetActive(false);
        TrialEnd.SetActive(true);
        BalloonPumpPage.SetActive(false);
        BalloonPopPage.SetActive(true);
        BalloonSuccessPage.SetActive(false);
        ThankYou.SetActive(false);
    }

    public void OpenThankYou(){
        BeforeYouStart.SetActive(false);
        Instructions.SetActive(false);
        TrialInstructions.SetActive(false);
        Trial.SetActive(false);
        Trial2.SetActive(false);
        TrialEnd.SetActive(false);
        BalloonPumpPage.SetActive(false);
        BalloonPopPage.SetActive(false);
        BalloonSuccessPage.SetActive(false);
        ThankYou.SetActive(true);

        StateNameController.BART_task_complete = true;
        StateNameController.total_reward = total_reward;
        StateNameController.trial_pop_pump = trial_pop_pump; //might need to change to refill dictionary
        StateNameController.trial_decisions = trial_decisions; //might need to change to refill dictionary
        StateNameController.update_vars = true;
    }
    

    public void UpdateSlider() {
      SliderPumps.text = "Pumps Chosen: " + mySlider.value;
      CurrentPumps.text = "Current Pumps: " + mySlider.value;
      CurrentReward.text = "Current Money: $"+(mySlider.value * 0.5);
      TotalReward.text = "Total Money: $" + total_reward;
    } //can call through update method

    public void LockButton(){
            pump = (int) mySlider.value;
            //pumptracker += pump;
            //mySlider.SetEnabled(false);
            BalloonChoiceVerdict();
    }

    public void CashOutButton(){
            StartCoroutine(SuccessPanelDelay());
            IEnumerator SuccessPanelDelay(){
            yield return new WaitForSeconds(2);
            OpenBalloonSuccessPanel();
            yield return new WaitForSeconds(2);
            OpenBalloonPumpPage();
            }
            trial_pop_pump.Add(new KeyValuePair<int, ArrayList>(originalpop, decisionvalues));
            trial_decisions.Add(new KeyValuePair<int, string>(trial, "success"));
            decisionvalues.Clear();
            Debug.Log(balloons[0]);
            Debug.Log(balloons[1]);
            balloons[0] = ((int) balloons[0] + 1);
            BalloonChoiceMain();
    }

    public void BalloonChoiceMain(){
        
        if(trial == 30){
            StartCoroutine(EndPanelDelay());
            IEnumerator EndPanelDelay(){
            yield return new WaitForSeconds(2);
            OpenThankYou();
            }
        }

        if(range.Count == 0){
            for (int i = 0; i < 128; i++){
            range.Insert(i, i);
            }
            Debug.Log(range.Count);
        
            for (int i = 0; i < 2; i++){
            balloons.Insert(i, 0);
            }
            trial_pop_pump.Clear();
            decisionvalues.Clear();
            trial_decisions.Clear();
        }
        //pumptracker = 0;
        OpenBalloonPumpPage();
        pump = 0;
        mySlider.value = 0;
        initreward = total_reward;
        trial+=1;
        Debug.Log(range.Count);
        pop_point = (int) (range[random.Next(1, range.Count - 1)]); //Random.Range(1, 129);
        originalpop = pop_point;
        range.Remove(pop_point);
    }

        //make sure to update dictionaries
       /* while(pop_point >= 0){
            pump = (int) mySlider.value;
            Debug.Log(pump);
            decisionvalues.Add(pump);
            pop_point -= pump;
            
            if(pop_point >= 0){
                OpenBalloonSuccessPanel();
                StartCoroutine(RestPanelDelay());
                IEnumerator RestPanelDelay(){
                yield return new WaitForSeconds(1);
                }
                total_reward += pump;
                BalloonChoice();
                //ADD DELAY
            }
            
        }
    }
    */

    public void BalloonChoiceMid(){
        mySlider.value = 0;
        CurrentPumps.text = "Current Pumps:" + mySlider.value;
        CurrentReward.text = "Current Money: $"+(mySlider.value * 0.5);
        TotalReward.text = "Total Money: $" + total_reward;
        OpenBalloonPumpPage();
        pump = 0;
    }

    public void BalloonChoiceVerdict(){
        decisionvalues.Add(pump);
        pop_point -= pump;
        Debug.Log(pop_point);
        if(pop_point>=0){
            StartCoroutine(SuccessPanelDelay());
            IEnumerator SuccessPanelDelay(){
            yield return new WaitForSeconds(2);
            OpenBalloonSuccessPanel();
            yield return new WaitForSeconds(2);
            OpenBalloonPumpPage();
            }
            total_reward += ((double) pump *  0.5);
            BalloonChoiceMid();
        }
        else{
            trial_decisions.Add(new KeyValuePair<int, string>(trial, "fail"));
            trial_pop_pump.Add(new KeyValuePair<int, ArrayList>(originalpop, decisionvalues));
            decisionvalues.Clear();
            balloons[1] = ((int) balloons[1] + 1);
            StartCoroutine(FailPanelDelay());
            IEnumerator FailPanelDelay(){
            yield return new WaitForSeconds(2);
            OpenBalloonPopPage();
            yield return new WaitForSeconds(2);
            OpenBalloonPumpPage();
            }
            total_reward = initreward;
            BalloonChoiceMain();
        }
    }
    

    // Update is called once per frame
    //void Update(){
        //key pressed update on choice page
       // if (Input.GetKeyUp(KeyCode.V)) { CashOutButton(); }
       // if (Input.GetKeyUp(KeyCode.B)) { LockButton(); }
        //add keys in instructions
    //}
}