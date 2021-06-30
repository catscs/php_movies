<?php


namespace Movie\User\Application\Register;


use Movie\User\Domain\UserBuilder;
use Movie\User\Domain\UserRepository;

class RegisterHandler
{
    /**
     * @var UserRepository
     */
    private UserRepository $userRepository;

    /**
     * RegisterHandler constructor.
     * @param UserRepository $userRepository
     */
    public function __construct(UserRepository $userRepository)
    {
        $this->userRepository = $userRepository;
    }

    public function __invoke(RegisterCommand $command)
    {
        $user = UserBuilder::create(
            $command->getUsername(),
            $command->getEmail(),
            $command->getPassword(),
            $command->getRoles()
        )->build();
        $response = $this->userRepository->register($user);
        return new RegisterResponse($response);
    }
}