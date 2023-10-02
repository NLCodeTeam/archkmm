package ru.rt.mlk.archkmm

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform