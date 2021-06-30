<?php


namespace Movie\User\Domain;


interface UserRepository
{
    public function register(User $user): bool;
}