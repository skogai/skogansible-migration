# Ansible Core Primitives - Every Basic Pattern

## 1. TASK COMPOSITION
# Include other task files (modularity/ordering)
- name: Setup AUR builder user
  ansible.builtin.include_tasks: aur_user.yml
  tags: [aur, aur_user]

## 2. PACKAGE STATE MANAGEMENT (pacman)
# Update package database cache
- name: Update pacman package database
  become: true
  community.general.pacman:
    update_cache: true

# Upgrade all packages
- name: Upgrade all packages
  become: true
  community.general.pacman:
    upgrade: true

# Install packages (ensure state=present)
- name: Install packages from list
  become: true
  community.general.pacman:
    name: "{{ packages }}"          # from vars
    state: present

# Install specific packages (inline list)
- name: Ensure base-devel and git are installed
  become: true
  community.general.pacman:
    name:
      - base-devel
      - git
    state: present

## 3. AUR PACKAGE MANAGEMENT (kewlfft.aur)
# Install from AUR using specific helper
- name: Install AUR packages using yay
  kewlfft.aur.aur:
    name: "{{ aur_packages }}"
    use: yay
    state: present
  become: true
  become_user: aur_builder
  vars:
    ansible_python_interpreter: /usr/bin/python
  when: aur_packages is defined and aur_packages | length > 0

## 4. USER MANAGEMENT
# Create user with properties
- name: Create the aur_builder user
  become: true
  ansible.builtin.user:
    name: aur_builder
    create_home: true
    group: wheel
    comment: "AUR package builder"
    shell: /bin/bash

## 5. FILE CONTENT MANAGEMENT (lineinfile)
# Ensure specific line exists in file
- name: Allow the aur_builder user to run sudo pacman without a password
  become: true
  ansible.builtin.lineinfile:
    path: /etc/sudoers.d/11-install-aur_builder
    line: 'aur_builder ALL=(ALL) NOPASSWD: /usr/bin/pacman'
    create: true
    mode: '0644'
    validate: 'visudo -cf %s'

## 6. PATH STATE QUERY (stat + register)
# Check if path exists and capture result
- name: Check if yay is already installed
  ansible.builtin.stat:
    path: /usr/bin/yay
  register: yay_stat

## 7. GIT REPOSITORY MANAGEMENT
# Clone or update git repo
- name: Clone yay repository from AUR
  become: true
  become_user: aur_builder
  ansible.builtin.git:
    repo: 'https://aur.archlinux.org/yay.git'
    dest: '/home/aur_builder/yay'
    update: true
    version: master
  when: not yay_stat.stat.exists

## 8. ARBITRARY COMMAND EXECUTION
# Run command with conditions
- name: Build and install yay
  become: true
  become_user: aur_builder
  ansible.builtin.command:
    cmd: makepkg -si --noconfirm --noprogressbar
    chdir: /home/aur_builder/yay
    creates: /usr/bin/yay           # idempotency: skip if exists
  when: not yay_stat.stat.exists

## 9. PATH DELETION (file state=absent)
# Remove path (file or directory)
- name: Clean up yay build directory
  become: true
  ansible.builtin.file:
    path: /home/aur_builder/yay
    state: absent
  when: not yay_stat.stat.exists

# ============================================================================
# MODIFIERS / CONTROL FLOW (used across all operations)
# ============================================================================

# become: true                     # Run as root
# become_user: username            # Run as specific user
# register: variable_name          # Capture output/state
# when: condition                  # Conditional execution
# tags: [tag1, tag2]              # Selective execution
# vars:                           # Task-level variables
#   key: value

# ============================================================================
# THE ACTUAL PRIMITIVES (distilled)
# ============================================================================

# 1. ensure_state(resource, properties)
#    - pacman: name=X state=present
#    - user: name=X group=Y shell=Z
#    - file: path=X state=absent

# 2. ensure_content(path, content, properties)
#    - lineinfile: path=X line=Y mode=Z validate=W

# 3. query_state(path)  register
#    - stat: path=X register=result

# 4. sync_repo(url, dest)
#    - git: repo=X dest=Y update=true

# 5. execute(command, context)
#    - command: cmd=X chdir=Y creates=Z

# 6. compose(subtasks)
#    - include_tasks: file.yml

# 7. update_cache/upgrade
#    - pacman: update_cache=true / upgrade=true

# That's it. 7 primitives total.
