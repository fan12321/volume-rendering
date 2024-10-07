#version 330 core
out vec4 FragColor;

in vec3 firstIntersection; // model space
uniform vec3 camera; // model space

uniform sampler2D texture1;

const int STEP = 1024;

vec3 getLastIntersection(vec3, vec3);
float linePlaneDistance(vec3, vec3, vec3, vec3, vec3); // the distance between a starting point of a line to a plane
float colorBlending(vec3, vec3);

void main()
{
	vec3 rayDirection = normalize(firstIntersection - camera);

	// vec2 TexCoord2D = vec2(firstIntersection.x, firstIntersection.z + firstIntersection.y/100.0);
	// float intensity = texture(texture1, TexCoord2D).r;
	// FragColor = vec4(intensity, intensity, intensity, 1);
	vec3 lastIntersection = getLastIntersection(firstIntersection, rayDirection);
	float l = colorBlending(firstIntersection, lastIntersection) / 1024.0;
	FragColor = vec4(l, l, l, 1);
}

float colorBlending(vec3 startingPoint, vec3 endingPoint) {
	vec3 stepVector = (endingPoint - startingPoint) / STEP;
	vec3 start = vec3(startingPoint);

	float intensity = 0.0;
	int i;
	for (i=0; i<STEP; i++) {
		float zFloor = floor(start.z * 10.0) / 10.0;
		float zCeil = ceil(start.z * 10.0) / 10.0;
		float fraction = fract(start.z * 10.0);
		vec2 TexCoord2DFloor = vec2(start.x, zFloor + start.y/100.0);
		vec2 TexCoord2DCeil = vec2(start.x, zCeil + start.y/100.0);
		intensity += mix(
			texture(texture1, TexCoord2DFloor).r, 
			texture(texture1, TexCoord2DCeil).r, 
			fraction
		) * 16.0;
		// FragColor = vec4(intensity, intensity, intensity, 1);
		start += stepVector;
	}
	return max(intensity, 1.0);
}

// find the intersection of the line and the six planes of an unit cube
vec3 getLastIntersection(vec3 startingPoint, vec3 dir) {
	float toPlane1 = linePlaneDistance(
		startingPoint, dir, vec3(0.0, 0.0, 0.0), vec3(1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0));
	float toPlane2 = linePlaneDistance(
		startingPoint, dir, vec3(0.0, 0.0, 0.0), vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0));
	float toPlane3 = linePlaneDistance(
		startingPoint, dir, vec3(0.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(0.0, 0.0, 1.0));
	float toPlane4 = linePlaneDistance(
		startingPoint, dir, vec3(1.0, 1.0, 1.0), vec3(1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0));
	float toPlane5 = linePlaneDistance(
		startingPoint, dir, vec3(1.0, 1.0, 1.0), vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0));
	float toPlane6 = linePlaneDistance(
		startingPoint, dir, vec3(1.0, 1.0, 1.0), vec3(0.0, 1.0, 0.0), vec3(0.0, 0.0, 1.0));

	float finalT = min(toPlane1, min(toPlane2, min(toPlane3, min(toPlane4, min(toPlane5, toPlane6)))));
	return startingPoint + finalT*dir;
}

float linePlaneDistance(vec3 startingPoint, vec3 lineDir, vec3 pointOnPlane, vec3 vector1, vec3 vector2) {
	vec3 planeNormal = normalize(cross(vector1, vector2));
	vec3 referenceVector = pointOnPlane - startingPoint;
	
	float denominator = dot(lineDir, planeNormal);
	float nominator = dot(referenceVector, planeNormal);
	return (nominator == 0.0) ? 999.9 : (
		(denominator == 0.0) ? 0.0 : (
			(nominator / denominator < 0.0)? 999.9 : nominator / denominator
		)
	);
}