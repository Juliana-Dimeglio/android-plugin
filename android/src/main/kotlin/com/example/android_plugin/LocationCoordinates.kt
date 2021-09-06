package com.example.android_plugin

import com.google.android.gms.location.LocationResult
import kotlin.math.pow
import kotlin.math.round

fun LocationResult.locationCoordinates(): String {
    return StringBuilder().append(AndroidPlugin.LONGITUDE_TAG)
        .append(" ")
        .append(this.lastLocation.longitude.run {
            this.cutToDecimals(2)
        })
        .append("%")
        .append(AndroidPlugin.LATITUDE_TAG)
        .append(" ")
        .append(this.lastLocation.latitude.run {
            this.cutToDecimals(2)
        }).toString()
}

fun Double.cutToDecimals(decimals: Int): Double {
    val digitCount = 10.toDouble().pow(decimals)
    return round(this * digitCount) / digitCount
}
