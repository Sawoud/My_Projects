import numpy as np
import open3d as o3d
import math
if __name__ == "__main__":


    file = open("cor_data.xyz","r")    
    num_lines = sum(1 for line in file)
    print(num_lines)
    file.close()
    val = math.ceil(num_lines/8)
    print(val)
    print("Testing IO for point cloud...")
    pcd = o3d.io.read_point_cloud("cor_data.xyz", format = 'xyz')

    print(pcd)

    print(np.asarray(pcd.points))
    #o3d.visualization.draw_geometries([pcd])

    pt1 = 0
    pt2 = 1
    pt3 = 2
    pt4 = 3
    pt5 = 4
    pt6 = 5
    pt7 = 6
    pt8 = 7
    po = 0

    lines = []
    # create planes
    for x in range(val):
        lines.append([pt1+po,pt2+po])
        lines.append([pt2+po,pt3+po])
        lines.append([pt3+po,pt4+po])
        lines.append([pt4+po,pt5+po])
        lines.append([pt5+po,pt6+po])
        lines.append([pt6+po,pt7+po])
        lines.append([pt7+po,pt8+po])
        lines.append([pt8+po,pt1+po])
        po += 8;

    #reset var
    pt1 = 0
    pt2 = 1
    pt3 = 2
    pt4 = 3
    pt5 = 4
    pt6 = 5
    pt7 = 6
    pt8 = 7
    po = 0
    do = 8
    # connect lines
    for x in range(val - 1):
        lines.append([pt1+po,pt1+do+po])
        lines.append([pt2+po,pt2+do+po])
        lines.append([pt3+po,pt3+do+po])
        lines.append([pt4+po,pt4+do+po])
        lines.append([pt5+po,pt5+do+po])
        lines.append([pt6+po,pt6+do+po])
        lines.append([pt7+po,pt7+do+po])
        lines.append([pt8+po,pt8+do+po])
        po += 8;

    line_set = o3d.geometry.LineSet(points = o3d.utility.Vector3dVector(np.asarray(pcd.points)), lines = o3d.utility.Vector2iVector(lines))

    #Show results
    o3d.visualization.draw_geometries([line_set])
    
