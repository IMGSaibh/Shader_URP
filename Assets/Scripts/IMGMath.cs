using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class IMGMath : MonoBehaviour
{
    // Start is called before the first frame update
    public GameObject go1;
    public GameObject go2;

    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(go1.transform.position, go2.transform.position);

        Gizmos.color = Color.yellow;
        //Vector3 normal = Vector3.Cross(go1.transform.position - Vector3.right, go2.transform.position);
        Vector3 normal = Vector3.Cross(Vector3.right, Vector3.forward);
        Gizmos.DrawLine(go1.transform.position, normal);
    }

}
