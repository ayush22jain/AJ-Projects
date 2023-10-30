using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.UIElements;

public class DelayDiscountingBehavior : MonoBehaviour
{
    //panel variables
    public GameObject WelcomePanel;
    public GameObject InstructionsPanel;
    public GameObject InstructionsTimerPanel;
    public GameObject GamePanelChoosing;
    public GameObject GamePanelResting;
    public GameObject EndPanel;
    public GameObject AltEndPanel;
    public Text LeftText;
    public Text RightText;
    public Text TimerText;

    //game variables
    public int adj_amount = 250;
    public int trial = 0;
    public int delay = 0;
    public int imm_amount = 500;
    public int delayed_amount = 1000;//fixed for now
    public bool random;
    public int imm_side; //0 == left, 1 == right
    public int user_selection;//0 == left, 1 == right
    public float start_time;
    public bool on_choice = false;

    /*delay var + indiff index meanings:
    0 == 1 day
    1 == 1 week
    2 == 1 month
    3 == 6 months
    4 == 1 years
    5 == 5 years
    6 == 25 years*/

    // default app startup
    void Start(){
        OpenWelcomePanel();
        random = Random.Range(0f, 1f) > 0.50;
        imm_side = random ? 0 : 1;
        UpdateText();

        //StateNameController.indifference_points = new int[7];
        for(int a = 0; a < 7; a++){
            StateNameController.indifference_points[a] = 1000;
        }
    }

    public void OpenHomePage(){
        //SceneManager.LoadScene("LogInSystem");
    }

    public void OpenWelcomePanel(){
        WelcomePanel.SetActive(true);
        InstructionsPanel.SetActive(false);
        InstructionsTimerPanel.SetActive(false);
        GamePanelChoosing.SetActive(false);
        GamePanelResting.SetActive(false);
        EndPanel.SetActive(false);
        AltEndPanel.SetActive(false);
    }

    public void OpenInstructionsPanel(){
        InstructionsPanel.SetActive(true);
        WelcomePanel.SetActive(false);
        InstructionsTimerPanel.SetActive(false);
        GamePanelChoosing.SetActive(false);
        GamePanelResting.SetActive(false);
        EndPanel.SetActive(false);
        AltEndPanel.SetActive(false);
    }

    public void OpenInstructionsTimerPanel(){
        InstructionsTimerPanel.SetActive(true);
        WelcomePanel.SetActive(false);
        InstructionsPanel.SetActive(false);
        GamePanelChoosing.SetActive(false);
        GamePanelResting.SetActive(false);
        EndPanel.SetActive(false);
        AltEndPanel.SetActive(false);
    }

    public void OpenGamePanelChoosing(){
        GamePanelChoosing.SetActive(true);
        WelcomePanel.SetActive(false);
        InstructionsPanel.SetActive(false);
        InstructionsTimerPanel.SetActive(false);
        GamePanelResting.SetActive(false);
        EndPanel.SetActive(false);
        AltEndPanel.SetActive(false);
        
        on_choice = true;
        start_time = Time.time;
    }

    public void OpenGamePanelResting(){
        GamePanelResting.SetActive(true);
        WelcomePanel.SetActive(false);
        InstructionsPanel.SetActive(false);
        InstructionsTimerPanel.SetActive(false);
        GamePanelChoosing.SetActive(false);
        EndPanel.SetActive(false);
        AltEndPanel.SetActive(false);
    }

    public void OpenEndPanel(){
        EndPanel.SetActive(true);
        WelcomePanel.SetActive(false);
        InstructionsPanel.SetActive(false);
        InstructionsTimerPanel.SetActive(false);
        GamePanelChoosing.SetActive(false);
        GamePanelResting.SetActive(false);
        AltEndPanel.SetActive(false);

        StateNameController.DD_task_complete = true;
        StateNameController.update_vars = true;
    }

    public void OpenAltEndPanel(){
        AltEndPanel.SetActive(true);
        WelcomePanel.SetActive(false);
        InstructionsPanel.SetActive(false);
        InstructionsTimerPanel.SetActive(false);
        GamePanelChoosing.SetActive(false);
        GamePanelResting.SetActive(false);
        EndPanel.SetActive(false);
    }

    public void LoadNextTrial(){
        OpenGamePanelResting();
        on_choice = false;
        TimerText.text = "";
        trial ++;
        if(user_selection == imm_side){
            StateNameController.indifference_points[delay] = imm_amount;
        }
        if(trial == 5){
            if(delay == 6) {
                OpenEndPanel();
                return;
            }
            delay++;
            trial = 0;
            imm_amount = 500;
            adj_amount = 250;
        }
        else{
            if(user_selection == imm_side){
                imm_amount -= adj_amount;
            }
            else{
                imm_amount += adj_amount;
            }
            adj_amount /= 2;
        }
        random = Random.Range(0f, 1f) > 0.50;
        imm_side = random ? 0 : 1;
        UpdateText();
        StartCoroutine(RestPanelDelay());
        IEnumerator RestPanelDelay(){
            yield return new WaitForSeconds(1);
            OpenGamePanelChoosing();
            }
    }
    
    public void LeftChoice(){
        if(on_choice) {
            user_selection = 0;
            LoadNextTrial();
        }
    }

    public void RightChoice(){
        if(on_choice) {
            user_selection = 1;
            LoadNextTrial();
        }
    }

    public void UpdateText(){
        string imm_text = "$" + imm_amount.ToString() + " NOW";
        string delayed_text = "$" + delayed_amount.ToString() + " in ";
        if(delay == 0){ delayed_text += "1 DAY"; }
        else if(delay == 1){ delayed_text += "1 WEEK"; }
        else if(delay == 2){ delayed_text += "1 MONTH"; }
        else if(delay == 3){ delayed_text += "6 MONTHS"; }
        else if(delay == 4){ delayed_text += "1 YEAR"; }
        else if(delay == 5){ delayed_text += "5 YEARS"; }
        else{ delayed_text += "25 YEARS"; }
        if(imm_side == 1){
            LeftText.text = delayed_text;
            RightText.text = imm_text;
        }
        else{
            LeftText.text = imm_text;
            RightText.text = delayed_text;
        }
    }

    // Update is called once per frame
    void Update(){
        //timer on choice page
        int time_left = (int)(180 - (Time.time - start_time));
        if(on_choice && time_left <= 60){
            TimerText.text = time_left.ToString();
            if(time_left <= 0){
                on_choice = false;
                TimerText.text = "";
                OpenAltEndPanel();
            }
        }

        //key pressed update on choice page
        if (Input.GetKeyUp(KeyCode.V)) { LeftChoice(); }
        if (Input.GetKeyUp(KeyCode.B)) { RightChoice(); }
    }
}
