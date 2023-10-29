using UnityEngine;

public class Clip_Object_to_Object : MonoBehaviour
{

    public Material material;

    // Update is called once per frame
    void Update()
    {
        Plane clip_plane = new Plane(transform.up, transform.position);
        Vector4 plane_representation = new Vector4(clip_plane.normal.x, clip_plane.normal.y, clip_plane.normal.z, clip_plane.distance);
        material.SetVector("_Plane", plane_representation);
    }
}
