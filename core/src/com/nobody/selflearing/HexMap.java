package com.nobody.selflearing;

import java.util.ArrayList;
import java.util.List;
import com.badlogic.gdx.math.Vector2;

public class HexMap extends Map {

	private List<Vector2[]> precalculatedPoints;
	private List<Hex> hexes;
	private int radius;
	private HexTopping topping;
	private float hexSize;
	private Vector2 mapCenter;
	
	public List<Vector2[]> getPointsToRender()
	{
		if(precalculatedPoints == null)
			CalculateMapPoints();
		
		return precalculatedPoints;
	}
	
	public List<Hex> getHexes()
	{
		return hexes;
	}
	
	public void CalculateMapPoints()
	{
		CalculatePointToppedPoints();
	}
	private void CalculatePointToppedPoints()
	{
		precalculatedPoints = new ArrayList<Vector2[]>();
		hexes = new ArrayList<Hex>();
		for(int i = -radius;i<=radius;i++)
			for(int j = -radius;j<=radius;j++)
			{
				if(i+j > radius || i+j < -radius)
					continue;
				
				hexes.add(new Hex(
					getHexCenterByAxialCor(new Coordinates(i,j)),
					new Coordinates(i,j)
				));
				precalculatedPoints.add(HexUtilites.getHexPoints(
						hexes.get(hexes.size()-1).getCenter(),
						hexSize,
						topping));
			}
	}
	
	private Vector2 getHexCenterByAxialCor(Coordinates coor)
	{
		return new Vector2(mapCenter.x + coor.r*hexSize + coor.c*hexSize*0.5f,mapCenter.y - coor.c*hexSize*0.75f);
		
	}
	
	public HexMap(Vector2 mapCenter, float hexSize ,int radius)
	{
		this.radius = radius;
		this.mapCenter = mapCenter;
		this.hexSize = hexSize;
		this.topping = HexTopping.Pointy;
	}
}
