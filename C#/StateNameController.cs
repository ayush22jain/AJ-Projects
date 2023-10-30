using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StateNameController : MonoBehaviour
{
    //update method
    public static bool update_vars;
    
    //completion variables
    public static bool DD_task_complete;
    public static bool GoNoGo_task_complete;
    public static bool StopSignal_task_complete;
    public static bool BART_task_complete;

    public static string platform;
    public static string MTURK_participant_ID;

    //TASK USER VARS
    //delay discounting
    public static int[] indifference_points = new int[7];

    //go no-go
    public static List<int> Incorrect = new List<int>();

    //stop signal
    public static Dictionary<int, List<bool>> correctness = new Dictionary<int, List<bool>>();
    public static Dictionary<int, float> listReactionTimes = new Dictionary<int, float>();

    //BART
    public static double total_reward;
    public static IDictionary<int, ArrayList> trial_pop_pump = new Dictionary<int, ArrayList>();
    public static IDictionary<int, string> trial_decisions = new Dictionary<int, string>();
    public static ArrayList balloons = new ArrayList();
}
